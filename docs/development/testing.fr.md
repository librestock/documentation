# Tests

Le système LibreStock Inventory utilise Jest pour les tests backend. Ce guide couvre les patterns de test et les bonnes pratiques.

## Vue d'ensemble

| Module | Framework | Statut |
|--------|-----------|--------|
| API | Jest + ts-jest | Actif |
| Web | - | Planifié |

## Exécuter les tests

### Tests API

```bash
# Exécuter tous les tests unitaires
pnpm --filter @librestock/api test

# Exécuter les tests en mode watch
pnpm --filter @librestock/api test:watch

# Exécuter les tests avec couverture
pnpm --filter @librestock/api test:cov

# Exécuter les tests end-to-end
pnpm --filter @librestock/api test:e2e
```

## Structure des tests

### Tests unitaires

Situés à côté des fichiers sources en `*.spec.ts` :

```
modules/api/src/routes/products/
├── products.service.ts
├── products.service.spec.ts    # Tests unitaires
├── products.controller.ts
└── ...
```

### Tests E2E

Situés dans `modules/api/test/` :

```
modules/api/test/
├── products.e2e-spec.ts
├── categories.e2e-spec.ts
└── jest-e2e.json
```

## Écrire des tests unitaires

### Pattern de test de service

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { ProductsService } from './products.service';
import { ProductRepository } from './product.repository';

describe('ProductsService', () => {
  let service: ProductsService;
  let productRepository: jest.Mocked<ProductRepository>;

  // Données de test
  const mockProduct = {
    id: '660e8400-e29b-41d4-a716-446655440000',
    sku: 'PROD-001',
    name: 'Produit Test',
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProductsService,
        {
          provide: ProductRepository,
          useValue: {
            findAllPaginated: jest.fn(),
            findById: jest.fn(),
            create: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<ProductsService>(ProductsService);
    productRepository = module.get(ProductRepository);
  });

  describe('findOne', () => {
    it('devrait retourner un produit', async () => {
      productRepository.findById.mockResolvedValue(mockProduct);

      const result = await service.findOne('some-id');

      expect(result).toEqual(mockProduct);
      expect(productRepository.findById).toHaveBeenCalledWith('some-id');
    });

    it('devrait lever NotFoundException si produit non trouvé', async () => {
      productRepository.findById.mockResolvedValue(null);

      await expect(service.findOne('invalid-id'))
        .rejects.toThrow(NotFoundException);
    });
  });
});
```

## Bonnes pratiques

1. **Isoler les tests** - Chaque test doit être indépendant
2. **Mocker les dépendances externes** - Base de données, APIs, etc.
3. **Nettoyer après les tests** - Utiliser `beforeEach`/`afterEach`
4. **Tester les cas limites** - Conditions d'erreur, données vides, etc.
5. **Utiliser des noms descriptifs** - `devrait lever NotFoundException quand...`

## Couverture

Générer le rapport de couverture :

```bash
pnpm --filter @librestock/api test:cov
```

Les rapports sont générés dans `modules/api/coverage/`.
