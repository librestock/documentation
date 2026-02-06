# Développement Frontend

Ce guide couvre les patterns de développement TanStack Start pour le frontend LibreStock Inventory.

## Stack technique

- TanStack Start (TanStack Router + Vite)
- React 19
- TanStack Query (état serveur)
- TanStack Form (gestion des formulaires)
- Tailwind CSS 4
- Radix UI / composants shadcn
- Better Auth
- i18next (traductions)

## Structure du projet

```
modules/web/src/
├── app/                     # Routes basées sur les fichiers (TanStack Router)
│   ├── __root.tsx           # Layout racine + providers
│   ├── index.tsx            # Accueil
│   ├── products.tsx         # Page produits
│   └── locations.$id.tsx    # Paramètres de route
├── components/
│   ├── ui/                  # Composants de base (Radix/shadcn)
│   ├── inventory/           # Fonctionnalités inventaire
│   └── common/              # Header, dialogs, etc.
├── hooks/providers/         # Contextes React
├── lib/
│   ├── data/
│   │   ├── axios-client.ts  # Client API
│   │   └── products.ts      # Hooks écrits à la main par feature
│   └── utils.ts             # Utilitaires
├── locales/                 # i18n (en, de, fr)
├── router.tsx               # Configuration du router
└── routeTree.gen.ts         # Routes générées
```

## Intégration API

### Client écrit à la main + Types partagés

Les hooks API sont dans `src/lib/data/*.ts` et utilisent les interfaces/enums
de `@librestock/types`.

### Utilisation des requêtes

```typescript
import { useListProducts } from '@/lib/data/products';

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

### Utilisation des mutations

```typescript
import { useCreateProduct, getListProductsQueryKey } from '@/lib/data/products';
import { useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';

function CreateProductForm() {
  const queryClient = useQueryClient();

  const mutation = useCreateProduct({
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: getListProductsQueryKey() });
      toast.success('Produit créé');
    },
    onError: () => {
      toast.error('Échec de la création du produit');
    },
  });

  const handleSubmit = async (data: CreateProductDto) => {
    await mutation.mutateAsync(data);
  };
}
```

## Formulaires

### TanStack Form + Zod

```typescript
import { useForm } from '@tanstack/react-form';
import { z } from 'zod';

const schema = z.object({
  name: z.string().min(1, 'Requis').max(100),
  sku: z.string().min(1, 'Requis').max(50),
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
            <FieldLabel>Nom</FieldLabel>
            <Input
              value={field.state.value}
              onChange={(e) => field.handleChange(e.target.value)}
            />
            <FieldError errors={field.state.meta.errors} />
          </Field>
        )}
      </form.Field>

      <Button type="submit" disabled={form.state.isSubmitting}>
        Enregistrer
      </Button>
    </form>
  );
}
```

## Routage

Les routes sont définies avec `createFileRoute` dans `src/app` :

```typescript
import { createFileRoute } from '@tanstack/react-router';
import { ProductFilters } from '@/components/products/ProductFilters';
import { ProductGrid } from '@/components/products/ProductGrid';

export const Route = createFileRoute('/products')({
  component: ProductsPage,
});

function ProductsPage() {
  return (
    <div className="page-container">
      <h1>Produits</h1>
      <ProductFilters />
      <ProductGrid />
    </div>
  );
}
```

## Sécurité SSR

TanStack Start rend côté serveur au premier chargement. Éviter les APIs
navigateur au niveau module ; utiliser `useEffect` ou
`typeof window !== 'undefined'` si nécessaire.

## Styles

### Tailwind CSS

Utiliser l'utilitaire `cn()` pour les classes conditionnelles :

```typescript
import { cn } from '@/lib/utils';

<div className={cn('p-4', isActive && 'bg-primary', className)} />
```

## Internationalisation

### Ajouter des traductions

```json
// locales/fr/common.json
{
  "navigation": {
    "products": "Produits",
    "categories": "Catégories"
  }
}
```

### Utiliser les traductions

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

## Bonnes pratiques

1. **Colocaliser la récupération de données** - Récupérer où les données sont utilisées
2. **Utiliser l'UI pending des routes** - Définir `pendingComponent` ou des limites de suspense
3. **Lazy load les composants lourds** - Utiliser `React.lazy` ou le code splitting des routes
4. **Garder les bundles petits** - Ne pas importer de bibliothèques lourdes inutilement

### Erreurs courantes à éviter

- Utiliser des APIs navigateur au niveau module pendant le SSR
- Invalider trop largement les requêtes au lieu de clés ciblées
- Mettre tout l'état au niveau de la page et faire du prop-drilling
- Récupérer sans clés de requête stables ou paramètres mémorisés
