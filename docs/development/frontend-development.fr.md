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
- i18next (en, de, fr)

## Structure du projet

```
frontend/src/
├── routes/                      # Routes basées sur les fichiers (TanStack Router)
│   ├── __root.tsx               # Layout racine + providers
│   ├── index.tsx                # Accueil (/)
│   ├── products.tsx             # Produits (/products)
│   ├── products.$id.tsx         # Détail produit (/products/:id)
│   ├── locations.tsx            # Emplacements (/locations)
│   ├── locations.$id.tsx        # Détail emplacement (/locations/:id)
│   ├── inventory.tsx            # Inventaire (/inventory)
│   ├── stock.tsx                # Stock (/stock)
│   ├── stock-movements.tsx      # Mouvements de stock (/stock-movements)
│   ├── orders.tsx               # Commandes (/orders)
│   ├── clients.tsx              # Clients (/clients)
│   ├── suppliers.tsx            # Fournisseurs (/suppliers)
│   ├── audit-logs.tsx           # Journal d'audit (/audit-logs)
│   ├── users.tsx                # Utilisateurs (/users)
│   ├── roles.tsx                # Rôles (/roles)
│   ├── settings.tsx             # Paramètres (/settings)
│   ├── login.tsx                # Connexion
│   └── signup.tsx               # Inscription
├── components/
│   ├── ui/                      # Composants de base (Radix/shadcn)
│   ├── areas/                   # Fonctionnalités zones
│   ├── audit-logs/              # Fonctionnalités journal d'audit
│   ├── category/                # Fonctionnalités catégories
│   ├── clients/                 # Fonctionnalités clients
│   ├── common/                  # Header, dialogs, etc.
│   ├── inventory/               # Fonctionnalités inventaire
│   ├── items/                   # Fonctionnalités articles
│   ├── locations/               # Fonctionnalités emplacements
│   ├── orders/                  # Fonctionnalités commandes
│   ├── products/                # Fonctionnalités produits
│   ├── roles/                   # Fonctionnalités rôles
│   ├── settings/                # Fonctionnalités paramètres
│   ├── stock-movements/         # Fonctionnalités mouvements de stock
│   ├── suppliers/               # Fonctionnalités fournisseurs
│   ├── users/                   # Fonctionnalités utilisateurs
│   ├── DefaultCatchBoundary.tsx # Limite d'erreur
│   └── NotFound.tsx             # Composant 404
├── hooks/providers/             # Contextes React
├── lib/
│   ├── data/
│   │   ├── areas.ts             # Hooks API zones
│   │   ├── audit-logs.ts        # Hooks API journal d'audit
│   │   ├── auth.ts              # Hooks API auth
│   │   ├── axios-client.ts      # Client API
│   │   ├── branding.ts          # Hooks API branding
│   │   ├── categories.ts        # Hooks API catégories
│   │   ├── clients.ts           # Hooks API clients
│   │   ├── inventory.ts         # Hooks API inventaire
│   │   ├── locations.ts         # Hooks API emplacements
│   │   ├── make-crud-hooks.ts   # Factory de hooks CRUD
│   │   ├── orders.ts            # Hooks API commandes
│   │   ├── photos.ts            # Hooks API photos
│   │   ├── products.ts          # Hooks API produits
│   │   ├── query-cache.ts       # Utilitaires cache de requêtes
│   │   ├── roles.ts             # Hooks API rôles
│   │   ├── stock-movements.ts   # Hooks API mouvements de stock
│   │   ├── suppliers.ts         # Hooks API fournisseurs
│   │   └── users.ts             # Hooks API utilisateurs
│   └── utils.ts                 # Utilitaires
├── locales/                     # i18n (en, de, fr)
├── router.tsx                   # Configuration du router
└── routeTree.gen.ts             # Routes générées
```

## Intégration API

### Client écrit à la main + Types partagés

Les hooks API sont dans `src/lib/data/*.ts` et utilisent les interfaces/enums
de `@librestock/types`. La factory `make-crud-hooks.ts` génère des hooks CRUD standards pour les ressources.

### Utilisation des requêtes

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

### Utilisation des mutations

```typescript
import { useCreateProduct, getListProductsQueryKey } from '~/lib/data/products';
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

Les routes sont définies avec `createFileRoute` dans `src/routes/` :

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
      <h1>Produits</h1>
      <ProductFilters />
      <ProductGrid />
    </div>
  );
}
```

### Liste des routes

| Fichier | Route |
|---------|-------|
| `__root.tsx` | Layout racine |
| `index.tsx` | `/` (Accueil) |
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

## Sécurité SSR

TanStack Start rend côté serveur au premier chargement. Éviter les APIs
navigateur au niveau module ; utiliser `useEffect` ou
`typeof window !== 'undefined'` si nécessaire.

## Composants

### Template de composant

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

## Styles

### Tailwind CSS

Utiliser l'utilitaire `cn()` pour les classes conditionnelles :

```typescript
import { cn } from '~/lib/utils';

<div className={cn('p-4', isActive && 'bg-primary', className)} />
```

### Variables CSS

Les couleurs du thème sont définies dans `globals.css` :

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

## Alias de chemin

Le frontend utilise `~/*` comme alias de chemin correspondant à `src/*` :

```typescript
// Au lieu de chemins relatifs :
import { Button } from '../../../components/ui/button';

// Utiliser l'alias :
import { Button } from '~/components/ui/button';
```

## Patterns courants

### États de chargement

```typescript
if (isLoading) return <Spinner />;
if (error) return <ErrorState error={error} />;
if (!data?.length) return <EmptyState />;
```

### Invalidation de requêtes

```typescript
queryClient.invalidateQueries({ queryKey: getListProductsQueryKey() });
```

### Récupération conditionnelle

```typescript
const query = useListProducts(params, { enabled: !!categoryId });
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
