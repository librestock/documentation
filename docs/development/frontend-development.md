# Frontend Development

This guide covers TanStack Start development patterns for the LibreStock Inventory frontend.

## Tech Stack

- TanStack Start (TanStack Router + Vite)
- React 19
- TanStack Query (server state)
- TanStack Form (form management)
- Tailwind CSS 4
- Radix UI / shadcn components
- Better Auth
- i18next (en, de, fr)

## Project Structure

```
frontend/src/
├── routes/                      # File-based routes (TanStack Router)
│   ├── __root.tsx               # Root layout + providers
│   ├── index.tsx                # Home (/)
│   ├── products.tsx             # Products (/products)
│   ├── products.$id.tsx         # Product detail (/products/:id)
│   ├── locations.tsx            # Locations (/locations)
│   ├── locations.$id.tsx        # Location detail (/locations/:id)
│   ├── inventory.tsx            # Inventory (/inventory)
│   ├── stock.tsx                # Stock (/stock)
│   ├── stock-movements.tsx      # Stock Movements (/stock-movements)
│   ├── orders.tsx               # Orders (/orders)
│   ├── clients.tsx              # Clients (/clients)
│   ├── suppliers.tsx            # Suppliers (/suppliers)
│   ├── audit-logs.tsx           # Audit logs (/audit-logs)
│   ├── users.tsx                # Users (/users)
│   ├── roles.tsx                # Roles (/roles)
│   ├── settings.tsx             # Settings (/settings)
│   ├── login.tsx                # Login
│   └── signup.tsx               # Signup
├── components/
│   ├── ui/                      # Base components (Radix/shadcn)
│   ├── areas/                   # Area features
│   ├── audit-logs/              # Audit log features
│   ├── category/                # Category features
│   ├── clients/                 # Client features
│   ├── common/                  # Header, dialogs, etc.
│   ├── inventory/               # Inventory features
│   ├── items/                   # Item features
│   ├── locations/               # Location features
│   ├── orders/                  # Order features
│   ├── products/                # Product features
│   ├── roles/                   # Role features
│   ├── settings/                # Settings features
│   ├── stock-movements/         # Stock movement features
│   ├── suppliers/               # Supplier features
│   ├── users/                   # User features
│   ├── DefaultCatchBoundary.tsx # Error boundary
│   └── NotFound.tsx             # 404 component
├── hooks/providers/             # React context
├── lib/
│   ├── data/
│   │   ├── areas.ts             # Area API hooks
│   │   ├── audit-logs.ts        # Audit log API hooks
│   │   ├── auth.ts              # Auth API hooks
│   │   ├── axios-client.ts      # API client
│   │   ├── branding.ts          # Branding API hooks
│   │   ├── categories.ts        # Category API hooks
│   │   ├── clients.ts           # Client API hooks
│   │   ├── inventory.ts         # Inventory API hooks
│   │   ├── locations.ts         # Location API hooks
│   │   ├── make-crud-hooks.ts   # CRUD hook factory
│   │   ├── orders.ts            # Order API hooks
│   │   ├── photos.ts            # Photo API hooks
│   │   ├── products.ts          # Product API hooks
│   │   ├── query-cache.ts       # Query cache utilities
│   │   ├── roles.ts             # Role API hooks
│   │   ├── stock-movements.ts   # Stock movement API hooks
│   │   ├── suppliers.ts         # Supplier API hooks
│   │   └── users.ts             # User API hooks
│   └── utils.ts                 # Utilities
├── locales/                     # i18n (en, de, fr)
├── router.tsx                   # Router setup
└── routeTree.gen.ts             # Generated routes
```

## API Integration

### Handwritten Client + Shared Types

API hooks live in `src/lib/data/*.ts` and use DTO interfaces/enums from
`@librestock/types`. The `make-crud-hooks.ts` factory generates standard CRUD hooks for resources.

### Using Queries

```typescript
import { useListProducts } from '~/lib/data/products';

function ProductList() {
  const { data, isLoading, error } = useListProducts({
    category_id: selectedCategory,
    page: 1,
    limit: 20,
  });

  if (isLoading) return <Spinner />;
  if (error) return <ErrorState error={error} />;
  if (!data?.data?.length) return <EmptyState />;

  return (
    <div>
      {data.data.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  );
}
```

### Using Mutations

```typescript
import { useCreateProduct, getListProductsQueryKey } from '~/lib/data/products';
import { useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';

function CreateProductForm() {
  const queryClient = useQueryClient();

  const mutation = useCreateProduct({
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: getListProductsQueryKey() });
      toast.success('Product created');
    },
    onError: () => {
      toast.error('Failed to create product');
    },
  });

  const handleSubmit = async (data: CreateProductDto) => {
    await mutation.mutateAsync(data);
  };
}
```

## Forms

### TanStack Form + Zod

```typescript
import { useForm } from '@tanstack/react-form';
import { z } from 'zod';

const schema = z.object({
  name: z.string().min(1, 'Required').max(100),
  sku: z.string().min(1, 'Required').max(50),
  category_id: z.string().uuid().optional(),
});

function ProductForm() {
  const form = useForm({
    defaultValues: { name: '', sku: '', category_id: '' },
    validators: { onSubmit: schema },
    onSubmit: async ({ value }) => {
      await mutation.mutateAsync(value);
    },
  });

  return (
    <form onSubmit={(e) => { e.preventDefault(); form.handleSubmit(); }}>
      <form.Field name="name">
        {(field) => (
          <Field>
            <FieldLabel>Name</FieldLabel>
            <Input
              value={field.state.value}
              onChange={(e) => field.handleChange(e.target.value)}
            />
            <FieldError errors={field.state.meta.errors} />
          </Field>
        )}
      </form.Field>

      <Button type="submit" disabled={form.state.isSubmitting}>
        Save
      </Button>
    </form>
  );
}
```

## Routing

Routes are defined with `createFileRoute` in `src/routes/`:

```typescript
import { createFileRoute } from '@tanstack/react-router';
import { ProductFilters } from '~/components/products/ProductFilters';
import { ProductGrid } from '~/components/products/ProductGrid';

export const Route = createFileRoute('/products')({
  component: ProductsPage,
});

function ProductsPage() {
  return (
    <div className="page-container">
      <h1>Products</h1>
      <ProductFilters />
      <ProductGrid />
    </div>
  );
}
```

### Route List

| File | Route |
|------|-------|
| `__root.tsx` | Root layout |
| `index.tsx` | `/` (Home) |
| `products.tsx` | `/products` |
| `products.$id.tsx` | `/products/:id` |
| `locations.tsx` | `/locations` |
| `locations.$id.tsx` | `/locations/:id` |
| `inventory.tsx` | `/inventory` |
| `stock.tsx` | `/stock` |
| `stock-movements.tsx` | `/stock-movements` |
| `orders.tsx` | `/orders` |
| `clients.tsx` | `/clients` |
| `suppliers.tsx` | `/suppliers` |
| `audit-logs.tsx` | `/audit-logs` |
| `users.tsx` | `/users` |
| `roles.tsx` | `/roles` |
| `settings.tsx` | `/settings` |
| `login.tsx` | `/login` |
| `signup.tsx` | `/signup` |

## SSR Safety

TanStack Start renders on the server for the initial HTML. Avoid browser-only
APIs at module scope; use `useEffect` or guard with
`typeof window !== 'undefined'` when needed.

## Components

### Component Template

```typescript
import { useTranslation } from 'react-i18next';
import { cn } from '~/lib/utils';
import { type ProductResponseDto } from '~/lib/data/products';

interface ProductCardProps {
  product: ProductResponseDto;
  className?: string;
}

export function ProductCard({ product, className }: ProductCardProps) {
  const { t } = useTranslation();

  return (
    <div className={cn('p-4 border rounded', className)}>
      <h3>{product.name}</h3>
      <p>{product.sku}</p>
    </div>
  );
}
```

## Styling

### Tailwind CSS

Use the `cn()` utility for conditional classes:

```typescript
import { cn } from '~/lib/utils';

<div className={cn('p-4', isActive && 'bg-primary', className)} />
```

### CSS Variables

Theme colors are defined in `globals.css`:

```css
:root {
  --primary: 220 90% 56%;
  --background: 0 0% 100%;
}

.dark {
  --primary: 220 90% 60%;
  --background: 0 0% 10%;
}
```

## Internationalization

### Adding Translations

```json
// locales/en/common.json
{
  "navigation": {
    "products": "Products",
    "categories": "Categories"
  }
}

// locales/fr/common.json
{
  "navigation": {
    "products": "Produits",
    "categories": "Catégories"
  }
}
```

### Using Translations

```typescript
import { useTranslation } from 'react-i18next';

function Header() {
  const { t, i18n } = useTranslation();

  return (
    <nav>
      <a href="/products">{t('navigation.products')}</a>
      <button onClick={() => i18n.changeLanguage('fr')}>FR</button>
    </nav>
  );
}
```

## Path Alias

The frontend uses `~/*` as a path alias mapping to `src/*`:

```typescript
// Instead of relative paths:
import { Button } from '../../../components/ui/button';

// Use the alias:
import { Button } from '~/components/ui/button';
```

## Common Patterns

### Loading States

```typescript
if (isLoading) return <Spinner />;
if (error) return <ErrorState error={error} />;
if (!data?.length) return <EmptyState />;
```

### Query Invalidation

```typescript
queryClient.invalidateQueries({ queryKey: getListProductsQueryKey() });
```

### Conditional Fetching

```typescript
const query = useListProducts(params, { enabled: !!categoryId });
```

## Best Practices

1. **Colocate data fetching** - Fetch where data is used
2. **Use route pending UI** - Set `pendingComponent` or suspense boundaries
3. **Lazy load heavy components** - Use `React.lazy` or route-level code splitting
4. **Keep bundles small** - Don't import heavy libraries unnecessarily

### Common Mistakes to Avoid

- Using browser-only APIs at module scope during SSR
- Over-invalidation of queries instead of scoped keys
- Putting all state at page level and prop-drilling
- Fetching without memoized query keys or stable params
