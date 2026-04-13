# Tests

Le backend LibreStock Inventory utilise Vitest pour les tests et Playwright pour les tests E2E frontend.

## Vue d'ensemble

| Module | Framework | Statut |
|--------|-----------|--------|
| Backend | Vitest | Actif |
| Frontend | Playwright | Actif |

## Exécuter les tests

### Tests Backend

```bash
# Exécuter tous les tests
pnpm --filter @librestock/api test

# Exécuter les tests en mode watch
pnpm --filter @librestock/api test:watch

# Exécuter les tests avec couverture
pnpm --filter @librestock/api test:cov

# Exécuter les tests d'intégration
pnpm --filter @librestock/api test:integration

# Exécuter un fichier de test spécifique
pnpm --filter @librestock/api test -- products
```

### Tests Frontend

```bash
# Exécuter les tests E2E Playwright
cd frontend
pnpm test:e2e
```

## Structure des tests

### Tests unitaires Backend

Situés à côté des fichiers sources en `*.spec.ts` ou `*.test.ts` :

```
backend/src/effect/modules/products/
├── service.ts
├── service.test.ts          # Tests unitaires
├── repository.ts
└── ...
```

## Écrire des tests unitaires

### Pattern de test de service

Les services Effect sont testés en fournissant des layers mock pour les dépendances :

```typescript
import { describe, it, expect } from "vitest";
import { Effect, Layer } from "effect";
import { ProductsService } from "./service";
import { ProductsRepository } from "./repository";

describe("ProductsService", () => {
  const mockProduct = {
    id: "660e8400-e29b-41d4-a716-446655440000",
    sku: "PROD-001",
    name: "Produit Test",
    is_active: true,
  };

  // Créer un layer mock du repository
  const MockProductsRepository = Layer.succeed(ProductsRepository, {
    findById: (id: string) => Effect.succeed(mockProduct),
    findBySku: (sku: string) => Effect.succeed(null),
    create: (data: any) => Effect.succeed({ ...mockProduct, ...data }),
  });

  const TestLayer = ProductsService.Default.pipe(
    Layer.provide(MockProductsRepository),
  );

  it("devrait retourner un produit par id", async () => {
    const result = await Effect.gen(function* () {
      const service = yield* ProductsService;
      return yield* service.findOne("some-id");
    }).pipe(Effect.provide(TestLayer), Effect.runPromise);

    expect(result.id).toBe(mockProduct.id);
  });

  it("devrait échouer avec ProductNotFound pour un id invalide", async () => {
    const EmptyRepo = Layer.succeed(ProductsRepository, {
      findById: () => Effect.succeed(null),
    });

    const layer = ProductsService.Default.pipe(Layer.provide(EmptyRepo));

    const result = await Effect.gen(function* () {
      const service = yield* ProductsService;
      return yield* service.findOne("invalid-id");
    }).pipe(Effect.provide(layer), Effect.either, Effect.runPromise);

    expect(result._tag).toBe("Left");
  });
});
```

### Tester les cas d'erreur

Utiliser `Effect.either` pour capturer les échecs attendus :

```typescript
it("devrait échouer quand le SKU existe déjà", async () => {
  const RepoWithExisting = Layer.succeed(ProductsRepository, {
    findBySku: () => Effect.succeed(mockProduct),
  });

  const layer = ProductsService.Default.pipe(Layer.provide(RepoWithExisting));

  const result = await Effect.gen(function* () {
    const service = yield* ProductsService;
    return yield* service.create({ sku: "PROD-001", name: "Duplicate" }, "user-id");
  }).pipe(Effect.provide(layer), Effect.either, Effect.runPromise);

  expect(result._tag).toBe("Left");
});
```

## Patterns de test

### Mocker les services Effect

Créer des implémentations mock avec `Layer.succeed` :

```typescript
const MockCategoriesService = Layer.succeed(CategoriesService, {
  existsById: (id: string) => Effect.succeed(true),
  findAll: () => Effect.succeed([]),
});

const TestLayer = ProductsService.Default.pipe(
  Layer.provide(MockProductsRepository),
  Layer.provide(MockCategoriesService),
);
```

## Couverture

Générer le rapport de couverture :

```bash
pnpm --filter @librestock/api test:cov
```

Les rapports sont générés dans `backend/coverage/`.

## Bonnes pratiques

1. **Utiliser `Layer.succeed` pour les mocks** — Fournit des implémentations mock type-safe
2. **Utiliser `Effect.either` pour tester les erreurs** — Capture les échecs attendus sans lever d'exception
3. **Isoler les tests** — Chaque test doit fournir ses propres layers
4. **Préférer les tests d'intégration pour les workflows** — Tester la logique inter-modules contre une vraie base de données
5. **Utiliser `Effect.runPromise`** — Convertit un Effect en promesse pour Vitest
6. **Tester les types d'erreurs explicitement** — Vérifier la classe d'erreur spécifique
7. **Garder les mocks minimaux** — Ne mocker que les méthodes utilisées par le test
