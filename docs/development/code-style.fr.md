# Style de code

Ce guide couvre les standards et conventions de codage utilisés dans LibreStock Inventory.

## Outils

| Outil | Objectif |
|-------|----------|
| ESLint | Linting |
| Prettier | Formatage |
| TypeScript | Vérification des types |

## Exécuter les vérifications

```bash
# Linter tous les packages
pnpm lint

# Corriger les problèmes auto-corrigeables
pnpm --filter @librestock/api lint --fix
pnpm --filter @librestock/web lint:fix

# Vérification des types
pnpm --filter @librestock/api build  # Inclut la vérification des types
```

## Configuration ESLint

Les deux repos utilisent ESLint. La configuration est partagée via `packages/eslint-config/`.

### Règles clés

**Ordre des imports** (appliqué) :

```typescript
// 1. Dépendances externes
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';

// 2. Modules internes
import { Product } from './entities/product.entity';
import { CreateProductDto } from './dto';
```

**Imports de types** :

```typescript
// Utiliser les imports de type inline
import { type ProductResponseDto } from '~/lib/data/products';
```

**Variables inutilisées** :

```typescript
// Préfixer avec underscore pour ignorer
const { data, error: _error } = useQuery();
```

## Configuration Prettier

### Backend

Le backend utilise un `.prettierrc` avec les paramètres suivants :

```json
{
  "singleQuote": true,
  "trailingComma": "all"
}
```

Toutes les autres valeurs utilisent les défauts de Prettier (printWidth: 80, semi: true, tabWidth: 2).

### Frontend

Le frontend utilise `prettier-plugin-tailwindcss` pour le tri automatique des classes Tailwind mais **n'a pas de `.prettierrc` personnalisé** -- il utilise les défauts de Prettier (guillemets doubles, printWidth: 80, semi: true, trailingComma: "all").

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
| Backend | `src/*` | `./src/*` |

## Conventions de nommage

### Fichiers

| Type | Convention | Exemple |
|------|------------|---------|
| Module Backend | kebab-case | `products.module.ts` |
| Entité Backend | singulier | `product.entity.ts` |
| DTO Backend | kebab-case | `create-product.dto.ts` |
| Composant Frontend | PascalCase | `ProductForm.tsx` |
| UI Frontend | kebab-case | `button.tsx` |

### Code

| Type | Convention | Exemple |
|------|------------|---------|
| Classe | PascalCase | `ProductsService` |
| Interface | PascalCase (sans préfixe I) | `ProductResponse` |
| Fonction | camelCase | `findAllProducts` |
| Constante | UPPER_SNAKE | `MAX_PAGE_SIZE` |
| Membre Enum | UPPER_SNAKE | `AuditAction.CREATE` |

### Structure d'un module Backend

```
routes/<feature>/
├── <feature>.module.ts      # ProductsModule
├── <feature>.controller.ts  # ProductsController
├── <feature>.service.ts     # ProductsService
├── <entity>.repository.ts   # ProductRepository (singulier)
├── entities/
│   └── <entity>.entity.ts   # Product (singulier)
└── dto/
    ├── create-<entity>.dto.ts
    ├── update-<entity>.dto.ts
    ├── <entity>-response.dto.ts
    └── index.ts             # Export barrel
```

### Structure des composants Frontend

```
components/
├── ui/                     # Composants de base (kebab-case)
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
- Préférer les exports nommés aux exports par défaut (utiliser les exports par défaut uniquement quand un outil l'exige)
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
type ButtonVariant = 'primary' | 'secondary' | 'danger';
```

### React

```typescript
// Composants fonction nommés
export function ProductCard({ product }: ProductCardProps) {
  return <div>...</div>;
}

// Déstructurer les props
function Button({ variant = 'primary', children, ...props }: ButtonProps) {
  return <button {...props}>{children}</button>;
}
```

### NestJS

```typescript
// Utiliser l'injection de dépendances
@Injectable()
export class ProductsService {
  constructor(
    private readonly productRepository: ProductRepository,
    private readonly categoryRepository: CategoryRepository,
  ) {}
}

// Utiliser les décorateurs pour la validation
@Post()
async create(@Body() createDto: CreateProductDto) {
  return this.productsService.create(createDto);
}
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
private buildTree(categories: Category[]): CategoryTreeNode[] {
  // Implémentation
}
```
