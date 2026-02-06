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

La configuration est partagée via `packages/eslint-config/`.

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
import { type ProductResponseDto } from '@/lib/data/products';
```

**Variables inutilisées** :

```typescript
// Préfixer avec underscore pour ignorer
const { data, error: _error } = useQuery();
```

## Configuration Prettier

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
| Web | `@/*` | `./src/*` |
| API | `src/*` | `./src/*` |

## Conventions de nommage

### Fichiers

| Type | Convention | Exemple |
|------|------------|---------|
| Module API | kebab-case | `products.module.ts` |
| Entité API | singulier | `product.entity.ts` |
| DTO API | kebab-case | `create-product.dto.ts` |
| Composant Web | PascalCase | `ProductForm.tsx` |
| UI Web | kebab-case | `button.tsx` |

### Code

| Type | Convention | Exemple |
|------|------------|---------|
| Classe | PascalCase | `ProductsService` |
| Interface | PascalCase (sans préfixe I) | `ProductResponse` |
| Fonction | camelCase | `findAllProducts` |
| Constante | UPPER_SNAKE | `MAX_PAGE_SIZE` |
| Membre Enum | UPPER_SNAKE | `AuditAction.CREATE` |

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
