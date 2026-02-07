# Code Style

This guide covers the coding standards and conventions used in LibreStock Inventory.

## Tools

| Tool | Purpose |
|------|---------|
| ESLint | Linting |
| Prettier | Formatting |
| TypeScript | Type checking |

## Running Checks

```bash
# Lint all packages
pnpm lint

# Fix auto-fixable issues
pnpm --filter @librestock/api lint --fix
pnpm --filter @librestock/web lint:fix

# Type check
pnpm --filter @librestock/api build  # Includes type check
```

## ESLint Configuration

Configuration is shared via `packages/eslint-config/`.

### Key Rules

**Import Order** (enforced):

```typescript
// 1. External dependencies
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';

// 2. Internal modules
import { Product } from './entities/product.entity';
import { CreateProductDto } from './dto';
```

**Type Imports**:

```typescript
// Use inline type imports
import { type ProductResponseDto } from '@/lib/data/products';
```

**Unused Variables**:

```typescript
// Prefix with underscore to ignore
const { data, error: _error } = useQuery();
```

## Prettier Configuration

```json
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 120,
  "tabWidth": 2
}
```

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
| Web | `@/*` | `./src/*` |
| API | `src/*` | `./src/*` |

## Naming Conventions

### Files

| Type | Convention | Example |
|------|------------|---------|
| API Module | kebab-case | `products.module.ts` |
| API Entity | singular | `product.entity.ts` |
| API DTO | kebab-case | `create-product.dto.ts` |
| Web Component | PascalCase | `ProductForm.tsx` |
| Web UI | kebab-case | `button.tsx` |

### Code

| Type | Convention | Example |
|------|------------|---------|
| Class | PascalCase | `ProductsService` |
| Interface | PascalCase (no I prefix) | `ProductResponse` |
| Function | camelCase | `findAllProducts` |
| Constant | UPPER_SNAKE | `MAX_PAGE_SIZE` |
| Enum Member | UPPER_SNAKE | `AuditAction.CREATE` |

### API Module Structure

```
routes/<feature>/
├── <feature>.module.ts      # ProductsModule
├── <feature>.controller.ts  # ProductsController
├── <feature>.service.ts     # ProductsService
├── <entity>.repository.ts   # ProductRepository (singular)
├── entities/
│   └── <entity>.entity.ts   # Product (singular)
└── dto/
    ├── create-<entity>.dto.ts
    ├── update-<entity>.dto.ts
    ├── <entity>-response.dto.ts
    └── index.ts             # Barrel export
```

### Web Module Structure

```
components/
├── ui/                     # Base components (kebab-case)
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
type ButtonVariant = 'primary' | 'secondary' | 'danger';
```

### React

```typescript
// Named function components
export function ProductCard({ product }: ProductCardProps) {
  return <div>...</div>;
}

// Destructure props
function Button({ variant = 'primary', children, ...props }: ButtonProps) {
  return <button {...props}>{children}</button>;
}
```

### NestJS

```typescript
// Use dependency injection
@Injectable()
export class ProductsService {
  constructor(
    private readonly productRepository: ProductRepository,
    private readonly categoryRepository: CategoryRepository,
  ) {}
}

// Use decorators for validation
@Post()
async create(@Body() createDto: CreateProductDto) {
  return this.productsService.create(createDto);
}
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
private buildTree(categories: Category[]): CategoryTreeNode[] {
  // Implementation
}
```
