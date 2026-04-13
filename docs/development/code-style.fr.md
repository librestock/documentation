# Style de code

Ce guide couvre les standards et conventions de codage utilisés dans LibreStock Inventory.

## Outils

| Outil | Portée | Objectif |
|-------|--------|----------|
| oxlint | Backend | Linting rapide |
| ESLint | Frontend | Linting |
| Prettier | Les deux | Formatage |
| TypeScript | Les deux | Vérification des types |

## Exécuter les vérifications

```bash
# Lint backend (oxlint)
pnpm --filter @librestock/api lint

# Lint backend avec auto-correction
pnpm --filter @librestock/api lint:fix

# Vérification des types backend
pnpm --filter @librestock/api type-check

# Lint frontend (ESLint)
pnpm --filter @librestock/web lint

# Lint frontend avec auto-correction
pnpm --filter @librestock/web lint:fix

# Build des types partagés (inclut la vérification des types)
pnpm --filter @librestock/types build
```

## Conventions d'import

### Backend (Effect.ts)

```typescript
// 1. Dépendances externes
import { Effect, Layer, Schema } from "effect";
import { HttpRouter, HttpServerRequest } from "@effect/platform";

// 2. Imports de la plateforme
import { requirePermission } from "../../platform/authorization";
import { DrizzleDatabase } from "../../platform/drizzle";

// 3. Imports locaux du module
import { ProductsService } from "./service";
import { CreateProductSchema } from "./products.schema";
```

### Frontend (React)

```typescript
// 1. Dépendances externes
import { useQuery } from "@tanstack/react-query";
import { createFileRoute } from "@tanstack/react-router";

// 2. Composants
import { Button } from "~/components/ui/button";

// 3. Utilitaires et types
import { type ProductResponseDto } from "~/lib/data/products";
```

**Imports de types** — utiliser le mot-clé `type` inline :

```typescript
import { type ProductResponseDto } from "~/lib/data/products";
```

**Variables inutilisées** — préfixer avec underscore :

```typescript
const { data, error: _error } = useQuery();
```

## Configuration Prettier

### Backend

Utilise `.prettierrc` avec :

```json
{
  "singleQuote": true,
  "trailingComma": "all"
}
```

### Frontend

Utilise `prettier-plugin-tailwindcss` pour le tri automatique des classes Tailwind. Pas de `.prettierrc` personnalisé — défauts de Prettier.

## TypeScript

### Mode strict

Tous les modules utilisent TypeScript strict :

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

### Alias de chemins

| Module | Alias | Correspond à |
|--------|-------|--------------|
| Frontend | `~/*` | `./src/*` |

## Conventions de nommage

### Fichiers

| Type | Convention | Exemple |
|------|------------|---------|
| Répertoire module backend | kebab-case | `stock-movements/` |
| Router backend | `router.ts` | `router.ts` |
| Service backend | `service.ts` | `service.ts` |
| Schéma backend | `<feature>.schema.ts` | `products.schema.ts` |
| Erreurs backend | `<feature>.errors.ts` | `products.errors.ts` |
| Composant frontend | PascalCase | `ProductForm.tsx` |
| UI frontend | kebab-case | `button.tsx` |

### Code

| Type | Convention | Exemple |
|------|------------|---------|
| Service Effect | PascalCase | `ProductsService` |
| Interface | PascalCase (sans préfixe I) | `ProductResponse` |
| Fonction | camelCase | `findAllProducts` |
| Constante | UPPER_SNAKE | `MAX_PAGE_SIZE` |
| Membre Enum | UPPER_SNAKE | `AuditAction.CREATE` |
| Schéma | PascalCase | `CreateProductSchema` |
| Classe d'erreur | PascalCase | `ProductNotFound` |

### Structure d'un module Backend

```
modules/<feature>/
├── router.ts              # Gestionnaires de routes HTTP
├── service.ts             # Logique métier (service Effect)
├── repository.ts          # Accès aux données (requêtes Drizzle)
├── <feature>.schema.ts    # Schémas de validation (Effect Schema)
├── <feature>.errors.ts    # Définitions d'erreurs de domaine
└── <feature>.utils.ts     # Mappers, helpers (optionnel)
```

### Structure des composants Frontend

```
components/
├── ui/                     # Composants de base (Radix/shadcn, kebab-case)
│   ├── button.tsx
│   └── input.tsx
├── products/               # Composants par feature (PascalCase)
│   ├── ProductForm.tsx
│   └── ProductList.tsx
└── common/                 # Composants partagés
    └── Header.tsx
```

## Bonnes pratiques

### Général

- Utiliser `const` par défaut, `let` uniquement si réassignation nécessaire
- Préférer les exports nommés aux exports par défaut
- Toujours utiliser des accolades pour les structures de contrôle
- Utiliser les retours anticipés pour réduire l'imbrication

### TypeScript

```typescript
// Préférer les interfaces pour les formes d'objets
interface ProductFormProps {
  product?: Product;
  onSubmit: (data: CreateProductDto) => void;
}

// Utiliser type pour les unions/intersections
type ButtonVariant = "primary" | "secondary" | "danger";
```

### React

```typescript
// Composants fonction nommés
export function ProductCard({ product }: ProductCardProps) {
  return <div>...</div>;
}
```

### Effect.ts

```typescript
// Les services yieldent leurs dépendances puis retournent les méthodes publiques
export class ProductsService extends Effect.Service<ProductsService>()(
  "ProductsService",
  {
    effect: Effect.gen(function* () {
      const repo = yield* ProductsRepository;
      return { findAll, create, update, delete: softDelete };
    }),
    dependencies: [ProductsRepository.Default],
  }
) {}
```

## Commentaires

- Éviter les commentaires évidents
- Documenter la logique métier complexe
- Utiliser JSDoc pour les APIs publiques

```typescript
/**
 * Construit un arbre hiérarchique à partir d'une liste plate de catégories.
 * Les catégories sans parent deviennent des nœuds racines.
 */
function buildTree(categories: Category[]): CategoryTreeNode[] {
  // Implémentation
}
```
