# Code Style

This guide covers the coding standards and conventions used in LibreStock Inventory.

## Tools

| Tool | Scope | Purpose |
|------|-------|---------|
| oxlint | Backend + Frontend | Fast Rust-based linting |
| Prettier | Both | Formatting |
| TypeScript | Both | Type checking |

!!! note "oxlint everywhere"
    Both backend and frontend use [oxlint](https://oxc-project.github.io/docs/guide/usage/linter.html). The `packages/eslint-config/` package exists for the (legacy) shared ESLint config but is not currently consumed by backend or frontend.

## Running Checks

```bash
# Backend lint
pnpm --filter @librestock/api lint

# Backend lint with auto-fix
pnpm --filter @librestock/api lint:fix

# Backend type check
pnpm --filter @librestock/api type-check

# Frontend lint
pnpm --filter @librestock/web lint

# Frontend lint with auto-fix
pnpm --filter @librestock/web lint:fix

# Build shared types — barrels first, then build
pnpm --filter @librestock/types barrels
pnpm --filter @librestock/types build
```

## Lint Configuration

Both packages use [oxlint](https://oxc-project.github.io/docs/guide/usage/linter.html). The frontend config lives at `frontend/.oxlintrc.json`.

Key rules enforced in the frontend:

- `unicorn/catch-error-name` — catch blocks must use `error`, not `e`
- `@typescript-eslint/unbound-method` — don't destructure methods from objects (use `obj.method()`)
- `prefer-destructuring` — use `const { x } = obj`, not `const x = obj.x`

## Import Conventions

### Backend (Effect.ts)

```typescript
// 1. External dependencies
import { Effect, Layer, Schema } from "effect";
import { HttpRouter, HttpServerRequest } from "@effect/platform";

// 2. Platform imports
import { requirePermission } from "../../platform/authorization";
import { DrizzleDatabase } from "../../platform/drizzle";

// 3. Local module imports
import { ProductsService } from "./service";
import { CreateProductSchema } from "./products.schema";
```

### Frontend (React)

```typescript
// 1. External dependencies
import { useQuery } from "@tanstack/react-query";
import { createFileRoute } from "@tanstack/react-router";

// 2. Components
import { Button } from "~/components/ui/button";
import { ProductCard } from "~/components/products/ProductCard";

// 3. Utilities and types
import { type ProductResponseDto } from "~/lib/data/products";
```

**Type imports** — use inline `type` keyword:

```typescript
import { type ProductResponseDto } from "~/lib/data/products";
```

**Unused variables** — prefix with underscore:

```typescript
const { data, error: _error } = useQuery();
```

## Prettier Configuration

### Backend

Uses `.prettierrc` with:

```json
{
  "singleQuote": true,
  "trailingComma": "all"
}
```

All other values use Prettier defaults (printWidth: 80, semi: true, tabWidth: 2).

### Frontend

Uses `prettier-plugin-tailwindcss` for automatic Tailwind class sorting. No custom `.prettierrc` — Prettier defaults (double quotes, printWidth: 80, semi: true, trailingComma: "all").

## TypeScript

### Strict Mode

All modules use strict TypeScript:

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

### Path Aliases

| Module | Alias | Maps to |
|--------|-------|---------|
| Frontend | `~/*` | `./src/*` |
| Frontend | `@/*` | `./src/*` (also available; used in e.g. `axios-client.ts`) |

## Naming Conventions

### Files

| Type | Convention | Example |
|------|------------|---------|
| Backend module dir | kebab-case | `stock-movements/` |
| Backend router | `router.ts` | `router.ts` |
| Backend service | `service.ts` | `service.ts` |
| Backend schema | `<feature>.schema.ts` | `products.schema.ts` |
| Backend errors | `<feature>.errors.ts` | `products.errors.ts` |
| Frontend Component | PascalCase | `ProductForm.tsx` |
| Frontend UI | kebab-case | `button.tsx` |

### Code

| Type | Convention | Example |
|------|------------|---------|
| Effect Service | PascalCase | `ProductsService` |
| Interface | PascalCase (no I prefix) | `ProductResponse` |
| Function | camelCase | `findAllProducts` |
| Constant | UPPER_SNAKE | `MAX_PAGE_SIZE` |
| Enum Member | UPPER_SNAKE | `AuditAction.CREATE` |
| Schema | PascalCase | `CreateProductSchema` |
| Error class | PascalCase | `ProductNotFound` |

### Backend Module Structure

```
modules/<feature>/
├── router.ts              # HTTP route handlers
├── service.ts             # Business logic (Effect service)
├── repository.ts          # Data access (Drizzle queries)
├── <feature>.schema.ts    # Validation schemas (Effect Schema)
├── <feature>.errors.ts    # Domain error definitions
└── <feature>.utils.ts     # Mappers, helpers (optional)
```

### Frontend Component Structure

```
components/
├── ui/                     # Base components (Radix/shadcn, kebab-case)
│   ├── button.tsx
│   └── input.tsx
├── products/               # Feature components (PascalCase)
│   ├── ProductForm.tsx
│   └── ProductList.tsx
└── common/                 # Shared components
    └── Header.tsx
```

## Best Practices

### General

- Use `const` by default, `let` only when reassignment is needed
- Prefer named exports over default exports (only use default exports when required by tooling)
- Always use braces for control statements
- Use early returns to reduce nesting

### TypeScript

```typescript
// Prefer interfaces for object shapes
interface ProductFormProps {
  product?: Product;
  onSubmit: (data: CreateProductDto) => void;
}

// Use type for unions/intersections
type ButtonVariant = "primary" | "secondary" | "danger";
```

### React

```typescript
// Named function components
export function ProductCard({ product }: ProductCardProps) {
  return <div>...</div>;
}

// Destructure props
function Button({ variant = "primary", children, ...props }: ButtonProps) {
  return <button {...props}>{children}</button>;
}
```

### Effect.ts

```typescript
// Services yield dependencies, then return public methods
export class ProductsService extends Effect.Service<ProductsService>()(
  "ProductsService",
  {
    effect: Effect.gen(function* () {
      const repo = yield* ProductsRepository;
      // ... define methods
      return { findAll, create, update, delete: softDelete };
    }),
    dependencies: [ProductsRepository.Default],
  }
) {}

// Routers follow: authorize → decode → service → respond
HttpRouter.post("/products", respondJson(
  Effect.gen(function* () {
    yield* requirePermission(Resource.PRODUCTS, Permission.WRITE);
    const body = yield* HttpServerRequest.schemaBodyJson(CreateProductSchema);
    const service = yield* ProductsService;
    return yield* service.create(body);
  }),
  { status: 201 }
));
```

## Comments

- Avoid obvious comments
- Document complex business logic
- Use JSDoc for public APIs

```typescript
/**
 * Builds a hierarchical tree from a flat list of categories.
 * Categories without a parent become root nodes.
 */
function buildTree(categories: Category[]): CategoryTreeNode[] {
  // Implementation
}
```
