# API Development

This guide covers Effect.ts development patterns for the LibreStock Inventory backend, which runs on Bun with Drizzle ORM and PostgreSQL.

## Module Structure

Each feature follows this structure:

```
modules/<feature>/
├── router.ts              # HTTP route handlers
├── service.ts             # Business logic (Effect service)
├── repository.ts          # Data access (Drizzle queries)
├── <feature>.schema.ts    # Validation schemas (Effect Schema)
├── <feature>.errors.ts    # Domain error definitions
└── <feature>.utils.ts     # Mappers, helpers (optional)
```

## Creating a New Module

### 1. Schema Definitions

Schemas define validation for request bodies and query parameters using Effect Schema:

```typescript
// products.schema.ts
import { Schema } from "effect";

export const CreateProductSchema = Schema.Struct({
  sku: Schema.Trim.pipe(Schema.minLength(1), Schema.maxLength(50)),
  name: Schema.Trim.pipe(Schema.minLength(1), Schema.maxLength(200)),
  category_id: Schema.optionalWith(Schema.NullOr(Schema.UUID), {
    default: () => null,
  }),
  standard_cost: Schema.optionalWith(Schema.NullOr(Schema.Number), {
    default: () => null,
  }),
}).annotations({ identifier: "CreateProduct" });

export const ProductsQuerySchema = Schema.Struct({
  page: Schema.optionalWith(Schema.NumberFromString, { default: () => 1 }),
  limit: Schema.optionalWith(Schema.NumberFromString, { default: () => 20 }),
  search: Schema.optionalWith(Schema.String, { default: () => "" }),
  sortBy: Schema.optionalWith(Schema.String, { default: () => "created_at" }),
  sortOrder: Schema.optionalWith(Schema.Literal("asc", "desc"), {
    default: () => "desc" as const,
  }),
}).annotations({ identifier: "ProductsQuery" });
```

!!! tip "Schema Annotations"
    Always add `.annotations({ identifier: '...' })` to schemas. The identifier appears in validation error messages and tracing spans, making debugging much easier.

### 2. Domain Errors

Define typed errors that map to HTTP status codes:

```typescript
// products.errors.ts
import { NotFoundError, BadRequestError, InternalError } from "../platform/errors";

export class ProductNotFound extends NotFoundError("ProductNotFound")<{
  readonly productId: string;
}> {}

export class ProductSkuConflict extends BadRequestError("ProductSkuConflict")<{
  readonly sku: string;
}> {}

export class ProductsInfrastructureError extends InternalError(
  "ProductsInfrastructureError"
)<{}> {}
```

Each error factory sets the HTTP status code automatically:

| Factory | Status | Use Case |
|---------|--------|----------|
| `NotFoundError` | 404 | Entity not found |
| `BadRequestError` | 400 | Validation, conflicts |
| `ConflictError` | 409 | Duplicate resources |
| `ForbiddenError` | 403 | Insufficient permissions |
| `UnauthorizedError` | 401 | Not authenticated |
| `InternalError` | 500 | Infrastructure failures |

### 3. Repository

Repositories handle data access using Drizzle ORM:

```typescript
// repository.ts
import { Effect } from "effect";
import { DrizzleDatabase } from "../../platform/drizzle";
import { products, categories } from "../../platform/db/schema";
import { eq, isNull, and } from "drizzle-orm";

export class ProductsRepository extends Effect.Service<ProductsRepository>()(
  "ProductsRepository",
  {
    effect: Effect.gen(function* () {
      const db = yield* DrizzleDatabase;

      const tryAsync = makeTryAsync(
        (error) => new ProductsInfrastructureError({ cause: error })
      );

      const findById = (id: string) =>
        tryAsync(() =>
          db.query.products.findFirst({
            where: and(eq(products.id, id), isNull(products.deleted_at)),
            with: { category: true },
          })
        );

      const create = (data: typeof products.$inferInsert) =>
        tryAsync(() =>
          db.insert(products).values(data).returning().then((r) => r[0]!)
        );

      return { findById, create /* ... */ };
    }),
    dependencies: [DrizzleDatabase.Default],
  }
) {}
```

!!! note "Error wrapping"
    The `makeTryAsync()` helper converts async database calls into typed Effects. If a query fails, it wraps the error in the module's infrastructure error (e.g., `ProductsInfrastructureError`), keeping error types explicit in the return channel.

### 4. Service

Services contain business logic and depend on repositories and other services:

```typescript
// service.ts
import { Effect } from "effect";

export class ProductsService extends Effect.Service<ProductsService>()(
  "ProductsService",
  {
    effect: Effect.gen(function* () {
      const repo = yield* ProductsRepository;
      const categoriesService = yield* CategoriesService;

      const getProductOrFail = (id: string) =>
        Effect.gen(function* () {
          const product = yield* repo.findById(id);
          if (!product) {
            return yield* Effect.fail(
              new ProductNotFound({ productId: id, messageKey: "products.notFound" })
            );
          }
          return product;
        });

      const create = (dto: CreateProduct, userId: string) =>
        Effect.gen(function* () {
          // Validate category exists
          if (dto.category_id) {
            yield* categoriesService.existsById(dto.category_id);
          }

          // Check SKU uniqueness
          const existing = yield* repo.findBySku(dto.sku);
          if (existing) {
            return yield* Effect.fail(
              new ProductSkuConflict({ sku: dto.sku, messageKey: "products.skuConflict" })
            );
          }

          return yield* repo.create({
            ...dto,
            created_by: userId,
            updated_by: userId,
          });
        }).pipe(Effect.withSpan("ProductsService.create"));

      return { create, getProductOrFail /* ... */ };
    }),
    dependencies: [ProductsRepository.Default, CategoriesService.Default],
  }
) {}
```

### 5. Router

Routers define HTTP endpoints and wire together authorization, validation, and service calls:

```typescript
// router.ts
import { HttpRouter, HttpServerRequest } from "@effect/platform";
import { Effect } from "effect";

export const ProductsRouter = HttpRouter.empty.pipe(
  // GET /products — paginated list
  HttpRouter.get("/products", respondJson(
    Effect.gen(function* () {
      yield* requirePermission(Resource.PRODUCTS, Permission.READ);
      const query = yield* searchParams(ProductsQuerySchema);
      const service = yield* ProductsService;
      return yield* service.findAllPaginated(query);
    })
  )),

  // POST /products — create
  HttpRouter.post("/products", respondJson(
    Effect.gen(function* () {
      yield* requirePermission(Resource.PRODUCTS, Permission.WRITE);
      const body = yield* HttpServerRequest.schemaBodyJson(CreateProductSchema);
      const session = yield* requireSession;
      const service = yield* ProductsService;

      const product = yield* service.create(body, session.user.id);

      // Fire-and-forget audit log
      const audit = yield* AuditLogWriter;
      yield* audit.log({
        action: AuditAction.CREATE,
        entityType: AuditEntityType.PRODUCT,
        entityId: product.id,
      });

      return product;
    }),
    { status: 201 }
  )),

  // PUT /products/:id — update
  HttpRouter.put("/products/:id", respondJson(
    Effect.gen(function* () {
      yield* requirePermission(Resource.PRODUCTS, Permission.WRITE);
      const { id } = yield* HttpRouter.schemaPathParams(
        Schema.Struct({ id: Schema.UUID })
      );
      const body = yield* HttpServerRequest.schemaBodyJson(UpdateProductSchema);
      const session = yield* requireSession;
      const service = yield* ProductsService;
      return yield* service.update(id, body, session.user.id);
    })
  )),

  // DELETE /products/:id — soft delete
  HttpRouter.delete("/products/:id", respondJson(
    Effect.gen(function* () {
      yield* requirePermission(Resource.PRODUCTS, Permission.WRITE);
      const { id } = yield* HttpRouter.schemaPathParams(
        Schema.Struct({ id: Schema.UUID })
      );
      const session = yield* requireSession;
      const service = yield* ProductsService;
      return yield* service.delete(id, session.user.id);
    })
  )),
);
```

### Route Handler Pattern

Every route handler follows the same sequence:

1. **Authorize** — `yield* requirePermission(Resource, Permission)`
2. **Decode** — Parse body, path params, or query params via schemas
3. **Get session** — `yield* requireSession` for the current user
4. **Call service** — Business logic and data access
5. **Audit** — Fire-and-forget via `AuditLogWriter.log()`
6. **Respond** — `respondJson()` wraps the result (or `respondEmpty()` for 204)

### 6. Layer Composition

Modules are wired together in `main.ts` using Effect layers — no decorator-based DI container:

```typescript
// main.ts (simplified)
const platformLayer = drizzleLayer.pipe(Layer.provideMerge(betterAuthLayer));

const rolesLayer = RolesService.Default.pipe(Layer.provide(platformLayer));
const permissionLayer = PermissionProvider.Default.pipe(Layer.provide(rolesLayer));

const categoriesLayer = CategoriesService.Default.pipe(Layer.provide(platformLayer));
const productsLayer = ProductsService.Default.pipe(
  Layer.provide(platformLayer),
  Layer.provide(categoriesLayer)
);
```

!!! tip "Dependency direction"
    Services export only their `.Default` layer. Cross-module access goes through the service layer — never import a repository from another module.

### 7. Update Shared Types

After changing DTOs or enums:

```bash
pnpm --filter @librestock/types barrels
pnpm --filter @librestock/types build
```

## Authentication

### Session Access

Authentication is handled by Better Auth. Sessions are accessed via Effect context:

```typescript
// Require authentication (fails with 401 if not logged in)
const session = yield* requireSession;
const userId = session.user.id;

// Optional session (returns null if not logged in)
const session = yield* getOptionalSession;
const userId = session?.user.id;
```

## Authorization

Use `requirePermission` at the start of every protected route handler:

```typescript
// Read access
yield* requirePermission(Resource.PRODUCTS, Permission.READ);

// Write access
yield* requirePermission(Resource.PRODUCTS, Permission.WRITE);
```

The `requirePermission` Effect:

1. Gets the current session (fails with 401 if unauthenticated)
2. Fetches the user's permissions via `PermissionProvider` (cached for 1 minute)
3. Checks if the user has the required permission
4. Fails with `PermissionDenied` (403) if not authorized

### Resources and Permissions

| Resource | Read | Write |
|----------|------|-------|
| `DASHBOARD` | View dashboard | — |
| `STOCK` | View stock & movements | Create/edit stock |
| `PRODUCTS` | View products | Create/edit/delete products |
| `LOCATIONS` | View locations & areas | Create/edit/delete locations |
| `INVENTORY` | View inventory | Adjust inventory |
| `AUDIT_LOGS` | View audit logs | — |
| `USERS` | View users | Manage users |
| `SETTINGS` | View settings | Update settings |
| `ROLES` | View roles | Manage roles |

## Error Handling

Errors are typed values in the Effect failure channel, not thrown exceptions:

```typescript
// Define a domain error
export class ProductNotFound extends NotFoundError("ProductNotFound")<{
  readonly productId: string;
}> {}

// Fail with a domain error (includes messageKey for localization)
yield* Effect.fail(
  new ProductNotFound({
    productId: id,
    messageKey: "products.notFound",
  })
);
```

### Error Response Flow

The `respondJson()` wrapper catches all errors and calls `respondCause()`, which:

1. **Domain errors** → HTTP status from error factory + localized message via `messageKey`
2. **Schema parse errors** → 400 with validation details
3. **Unknown errors** → 500 (masked in production, detailed in development)

All error responses include `x-request-id` for tracing.

### Localized Messages

Error messages are resolved from locale catalogs (en, fr, de) based on the `Accept-Language` header:

```typescript
// English catalog
"products.notFound": "Product not found",
"products.skuConflict": "A product with this SKU already exists",

// French catalog
"products.notFound": "Produit non trouvé",
"products.skuConflict": "Un produit avec ce SKU existe déjà",
```

## Soft Delete

Products use soft delete via `deleted_at`, `deleted_by` columns:

```typescript
// Repository — exclude deleted by default
const findAll = () =>
  tryAsync(() =>
    db.query.products.findMany({
      where: isNull(products.deleted_at),
    })
  );

// Include deleted (for admin views)
const findAllIncludingDeleted = () =>
  tryAsync(() => db.query.products.findMany());

// Soft delete
const softDelete = (id: string, userId: string) =>
  tryAsync(() =>
    db.update(products)
      .set({ deleted_at: new Date(), deleted_by: userId })
      .where(eq(products.id, id))
  );

// Restore
const restore = (id: string) =>
  tryAsync(() =>
    db.update(products)
      .set({ deleted_at: null, deleted_by: null })
      .where(eq(products.id, id))
  );
```

## Response Formats

### Single Entity

```json
{
  "id": "uuid",
  "name": "Product Name",
  "_links": {
    "self": { "href": "/api/v1/products/uuid", "method": "GET" }
  }
}
```

### Paginated List

```json
{
  "data": [...],
  "page": 1,
  "limit": 20,
  "total": 100
}
```

### Bulk Operation

```json
{
  "succeeded": ["id1", "id2"],
  "failed": [
    { "item": { "sku": "PROD-003" }, "error": "SKU already exists" }
  ]
}
```

## HATEOAS Links

HATEOAS links are added to responses via the `addHateoasLinks()` utility:

```typescript
import { addHateoasLinks } from "../../platform/hateoas";

const links = [
  { rel: "self", href: `/products/${product.id}`, method: "GET" },
  { rel: "update", href: `/products/${product.id}`, method: "PUT" },
  { rel: "delete", href: `/products/${product.id}`, method: "DELETE" },
];

return addHateoasLinks(productDto, links);
```

The `getBaseUrl()` helper resolves the protocol from `x-forwarded-proto` for correct URLs behind reverse proxies.

## Audit Logging

Audit logging is fire-and-forget — it runs in a background daemon fiber and never blocks the response:

```typescript
const audit = yield* AuditLogWriter;
yield* audit.log({
  action: AuditAction.CREATE,
  entityType: AuditEntityType.PRODUCT,
  entityId: product.id,
});
```

The audit writer automatically captures:

- **User ID** — from the current session
- **IP address** — from request context
- **User agent** — from request headers
- **Timestamp** — current time

### Audit Actions

| Action | When |
|--------|------|
| `CREATE` | Entity created |
| `UPDATE` | Entity modified |
| `DELETE` | Entity deleted |
| `RESTORE` | Soft-deleted entity restored |
| `ADJUST_QUANTITY` | Inventory quantity changed |
| `ADD_PHOTO` | Photo uploaded |
| `STATUS_CHANGE` | Status field changed (e.g., order status) |

## Tracing

Service methods use `Effect.withSpan()` for distributed tracing:

```typescript
const create = (dto: CreateProduct, userId: string) =>
  Effect.gen(function* () {
    // ... business logic
  }).pipe(Effect.withSpan("ProductsService.create"));
```

Spans appear in structured logs and can be exported to tracing backends.

## HTTP Middleware

The HTTP app applies middleware in order (innermost first):

| Middleware | Purpose |
|-----------|---------|
| `corsMiddleware` | CORS headers for cross-origin requests |
| `securityHeadersMiddleware` | Security headers (CSP, X-Frame-Options, etc.) |
| `requestLoggingMiddleware` | Request/response logging with timing |
| `bodyLimitMiddleware` | Max 10MB request body |

All responses include `x-request-id` for request correlation.

## Health Checks

### Endpoints

#### Full Health Check

`GET /health-check`

Checks database connectivity and auth configuration:

```json
{
  "status": "ok",
  "checks": {
    "database": "up",
    "auth": "configured"
  }
}
```

Returns `503` if any check fails.

#### Liveness Probe

`GET /health-check/live`

Returns `200` if the process is running.

#### Readiness Probe

`GET /health-check/ready`

Checks database connectivity. Returns `503` if the database is unreachable.

### Kubernetes Configuration

```yaml
livenessProbe:
  httpGet:
    path: /health-check/live
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /health-check/ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```
