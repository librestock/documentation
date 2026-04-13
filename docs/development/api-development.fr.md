# Développement API

Ce guide couvre les patterns de développement Effect.ts pour le backend LibreStock Inventory, qui tourne sur Bun avec Drizzle ORM et PostgreSQL.

## Structure des modules

Chaque fonctionnalité suit cette structure :

```
modules/<feature>/
├── router.ts              # Gestionnaires de routes HTTP
├── service.ts             # Logique métier (service Effect)
├── repository.ts          # Accès aux données (requêtes Drizzle)
├── <feature>.schema.ts    # Schémas de validation (Effect Schema)
├── <feature>.errors.ts    # Définitions d'erreurs de domaine
└── <feature>.utils.ts     # Mappers, helpers (optionnel)
```

## Créer un nouveau module

### 1. Définitions de schémas

Les schémas définissent la validation des corps de requête et paramètres avec Effect Schema :

```typescript
// products.schema.ts
import { Schema } from "effect";

export const CreateProductSchema = Schema.Struct({
  sku: Schema.Trim.pipe(Schema.minLength(1), Schema.maxLength(50)),
  name: Schema.Trim.pipe(Schema.minLength(1), Schema.maxLength(200)),
  category_id: Schema.optionalWith(Schema.NullOr(Schema.UUID), {
    default: () => null,
  }),
}).annotations({ identifier: "CreateProduct" });
```

!!! tip "Annotations de schéma"
    Ajoutez toujours `.annotations({ identifier: '...' })` aux schémas. L'identifiant apparaît dans les messages d'erreur de validation et les spans de traçage.

### 2. Erreurs de domaine

Définir des erreurs typées qui correspondent aux codes HTTP :

```typescript
// products.errors.ts
import { NotFoundError, BadRequestError, InternalError } from "../platform/errors";

export class ProductNotFound extends NotFoundError("ProductNotFound")<{
  readonly productId: string;
}> {}

export class ProductSkuConflict extends BadRequestError("ProductSkuConflict")<{
  readonly sku: string;
}> {}
```

Chaque factory d'erreur définit automatiquement le code HTTP :

| Factory | Status | Cas d'utilisation |
|---------|--------|-------------------|
| `NotFoundError` | 404 | Entité non trouvée |
| `BadRequestError` | 400 | Validation, conflits |
| `ConflictError` | 409 | Ressources dupliquées |
| `ForbiddenError` | 403 | Permissions insuffisantes |
| `UnauthorizedError` | 401 | Non authentifié |
| `InternalError` | 500 | Erreurs d'infrastructure |

### 3. Repository

Les repositories gèrent l'accès aux données via Drizzle ORM :

```typescript
// repository.ts
import { Effect } from "effect";
import { DrizzleDatabase } from "../../platform/drizzle";

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

      return { findById /* ... */ };
    }),
    dependencies: [DrizzleDatabase.Default],
  }
) {}
```

### 4. Service

Les services contiennent la logique métier :

```typescript
// service.ts
export class ProductsService extends Effect.Service<ProductsService>()(
  "ProductsService",
  {
    effect: Effect.gen(function* () {
      const repo = yield* ProductsRepository;
      const categoriesService = yield* CategoriesService;

      const create = (dto: CreateProduct, userId: string) =>
        Effect.gen(function* () {
          if (dto.category_id) {
            yield* categoriesService.existsById(dto.category_id);
          }
          const existing = yield* repo.findBySku(dto.sku);
          if (existing) {
            return yield* Effect.fail(
              new ProductSkuConflict({ sku: dto.sku, messageKey: "products.skuConflict" })
            );
          }
          return yield* repo.create({ ...dto, created_by: userId });
        }).pipe(Effect.withSpan("ProductsService.create"));

      return { create /* ... */ };
    }),
    dependencies: [ProductsRepository.Default, CategoriesService.Default],
  }
) {}
```

### 5. Router

Les routers définissent les endpoints HTTP :

```typescript
// router.ts
export const ProductsRouter = HttpRouter.empty.pipe(
  HttpRouter.get("/products", respondJson(
    Effect.gen(function* () {
      yield* requirePermission(Resource.PRODUCTS, Permission.READ);
      const query = yield* searchParams(ProductsQuerySchema);
      const service = yield* ProductsService;
      return yield* service.findAllPaginated(query);
    })
  )),

  HttpRouter.post("/products", respondJson(
    Effect.gen(function* () {
      yield* requirePermission(Resource.PRODUCTS, Permission.WRITE);
      const body = yield* HttpServerRequest.schemaBodyJson(CreateProductSchema);
      const session = yield* requireSession;
      const service = yield* ProductsService;
      const product = yield* service.create(body, session.user.id);

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
);
```

### Pattern des gestionnaires de routes

Chaque gestionnaire suit la même séquence :

1. **Autoriser** — `yield* requirePermission(Resource, Permission)`
2. **Décoder** — Parser le corps, les paramètres de chemin ou de requête
3. **Session** — `yield* requireSession` pour l'utilisateur courant
4. **Service** — Logique métier et accès aux données
5. **Audit** — Fire-and-forget via `AuditLogWriter.log()`
6. **Répondre** — `respondJson()` enveloppe le résultat

### 6. Composition des couches

Les modules sont câblés dans `main.ts` via les layers Effect :

```typescript
// main.ts (simplifié)
const platformLayer = drizzleLayer.pipe(Layer.provideMerge(betterAuthLayer));
const rolesLayer = RolesService.Default.pipe(Layer.provide(platformLayer));
const productsLayer = ProductsService.Default.pipe(
  Layer.provide(platformLayer),
  Layer.provide(categoriesLayer)
);
```

!!! tip "Direction des dépendances"
    Les services n'exportent que leur layer `.Default`. L'accès inter-modules passe par la couche service — jamais importer un repository d'un autre module.

### 7. Mise à jour des types partagés

```bash
pnpm --filter @librestock/types barrels
pnpm --filter @librestock/types build
```

## Authentification

### Accès à la session

L'authentification est gérée par Better Auth. Les sessions sont accessibles via le contexte Effect :

```typescript
// Requiert l'authentification (échoue avec 401 si non connecté)
const session = yield* requireSession;
const userId = session.user.id;

// Session optionnelle (retourne null si non connecté)
const session = yield* getOptionalSession;
```

## Autorisation

Utiliser `requirePermission` au début de chaque route protégée :

```typescript
yield* requirePermission(Resource.PRODUCTS, Permission.READ);
yield* requirePermission(Resource.PRODUCTS, Permission.WRITE);
```

L'Effect `requirePermission` :

1. Obtient la session courante (échoue avec 401 si non authentifié)
2. Récupère les permissions via `PermissionProvider` (cache de 1 minute)
3. Vérifie la permission requise
4. Échoue avec `PermissionDenied` (403) si non autorisé

## Gestion des erreurs

Les erreurs sont des valeurs typées dans le canal d'échec Effect :

```typescript
// Échouer avec une erreur de domaine (inclut messageKey pour la localisation)
yield* Effect.fail(
  new ProductNotFound({
    productId: id,
    messageKey: "products.notFound",
  })
);
```

### Messages localisés

Les messages sont résolus depuis les catalogues de langues (en, fr, de) selon l'en-tête `Accept-Language`.

## Soft Delete

Les produits utilisent la suppression logique via `deleted_at`, `deleted_by` :

```typescript
// Repository — exclure les supprimés par défaut
const findAll = () =>
  tryAsync(() =>
    db.query.products.findMany({
      where: isNull(products.deleted_at),
    })
  );

// Suppression logique
const softDelete = (id: string, userId: string) =>
  tryAsync(() =>
    db.update(products)
      .set({ deleted_at: new Date(), deleted_by: userId })
      .where(eq(products.id, id))
  );
```

## Formats de réponse

### Entité unique

```json
{
  "id": "uuid",
  "name": "Nom du produit",
  "_links": {
    "self": { "href": "/api/v1/products/uuid", "method": "GET" }
  }
}
```

### Liste paginée

```json
{
  "data": [...],
  "page": 1,
  "limit": 20,
  "total": 100
}
```

### Opération en masse

```json
{
  "succeeded": ["id1", "id2"],
  "failed": [
    { "item": { "sku": "PROD-003" }, "error": "Le SKU existe déjà" }
  ]
}
```

## Journalisation d'audit

La journalisation est fire-and-forget — elle s'exécute dans une fibre daemon en arrière-plan :

```typescript
const audit = yield* AuditLogWriter;
yield* audit.log({
  action: AuditAction.CREATE,
  entityType: AuditEntityType.PRODUCT,
  entityId: product.id,
});
```

## Traçage

Les méthodes de service utilisent `Effect.withSpan()` pour le traçage distribué :

```typescript
const create = (dto: CreateProduct, userId: string) =>
  Effect.gen(function* () {
    // ... logique métier
  }).pipe(Effect.withSpan("ProductsService.create"));
```

## Middleware HTTP

L'application HTTP applique les middlewares dans l'ordre :

| Middleware | Objectif |
|-----------|----------|
| `corsMiddleware` | En-têtes CORS |
| `securityHeadersMiddleware` | En-têtes de sécurité |
| `requestLoggingMiddleware` | Journalisation requêtes/réponses |
| `bodyLimitMiddleware` | Corps de requête max 10 Mo |

## Health Checks

### Endpoints

- `GET /health-check` — Vérification complète (base de données + auth). Retourne `503` si un check échoue.
- `GET /health-check/live` — Sonde de vivacité. Retourne `200` si le processus tourne.
- `GET /health-check/ready` — Sonde de disponibilité. Vérifie la base de données.

### Configuration Kubernetes

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
