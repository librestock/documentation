# Tests

Le système LibreStock Inventory utilise Jest pour les tests backend. Ce guide couvre les patterns de test et les bonnes pratiques.

## Vue d'ensemble

| Module | Framework | Statut |
|--------|-----------|--------|
| Backend | Jest 30 + ts-jest | Actif |
| Frontend | - | Planifié |

## Exécuter les tests

### Tests Backend

```bash
# Exécuter tous les tests unitaires
pnpm --filter @librestock/api test

# Exécuter les tests en mode watch
pnpm --filter @librestock/api test:watch

# Exécuter les tests avec couverture
pnpm --filter @librestock/api test:cov

# Exécuter les tests end-to-end
pnpm --filter @librestock/api test:e2e

# Exécuter un fichier de test spécifique (Jest 30 utilise --testPathPatterns, au pluriel)
pnpm --filter @librestock/api test -- --testPathPatterns products
```

!!! warning "Flag Jest 30"
    Jest 30 utilise `--testPathPatterns` (au pluriel), pas `--testPathPattern`. L'utilisation de la forme au singulier échouera silencieusement.

## Structure des tests

### Tests unitaires

Situés à côté des fichiers sources en `*.spec.ts` :

```
backend/src/routes/products/
├── products.service.ts
├── products.service.spec.ts    # Tests unitaires
├── products.controller.ts
└── ...
```

### Tests E2E

Situés dans `backend/test/` :

```
backend/test/
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

### Pattern de test de contrôleur

Pour tester les contrôleurs, remplacer `PermissionGuard` (pas le guard d'authentification) car `PermissionGuard` dépend de `DataSource` :

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { PermissionGuard } from 'src/common/guards/permission.guard';

describe('ProductsController', () => {
  let controller: ProductsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ProductsController],
      providers: [/* ... */],
    })
      .overrideGuard(PermissionGuard)
      .useValue({ canActivate: () => true })
      .compile();

    controller = module.get<ProductsController>(ProductsController);
  });

  // ... tests
});
```

## Écrire des tests E2E

### Pattern de configuration

Les tests E2E remplacent le `AuthGuard` pour simuler l'authentification :

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';
import { AuthGuard } from '../src/common/auth/auth.guard';

describe('ProductsController (e2e)', () => {
  let app: INestApplication;

  // Mock du guard d'authentification
  const mockAuthGuard = {
    canActivate: jest.fn().mockImplementation((context) => {
      const req = context.switchToHttp().getRequest();
      req.auth = { userId: 'test-user-id', sessionId: 'test-session-id' };
      return true;
    }),
  };

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideGuard(AuthGuard)
      .useValue(mockAuthGuard)
      .compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('GET /api/v1/products', () => {
    it('devrait retourner les produits paginés', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/products')
        .set('Authorization', 'Bearer token')
        .expect(200);

      expect(response.body.data).toBeDefined();
      expect(response.body.meta.total).toBeDefined();
    });
  });
});
```

## Utilitaires de test

### Tester les opérations asynchrones fire-and-forget

Utiliser le pattern `flushPromises` pour tester les opérations asynchrones fire-and-forget (ex: journalisation d'audit) :

```typescript
const flushPromises = () =>
  new Promise((resolve) => setImmediate(resolve));

it('devrait créer un log d\'audit', async () => {
  interceptor.intercept(mockContext, mockHandler).subscribe();

  await flushPromises();

  expect(auditLogService.log).toHaveBeenCalled();
});
```

## Couverture

Générer le rapport de couverture :

```bash
pnpm --filter @librestock/api test:cov
```

Les rapports sont générés dans `backend/coverage/`.

## Bonnes pratiques

1. **Isoler les tests** - Chaque test doit être indépendant
2. **Mocker les dépendances externes** - Base de données, APIs, etc.
3. **Nettoyer après les tests** - Utiliser `beforeEach`/`afterEach`
4. **Tester les cas limites** - Conditions d'erreur, données vides, etc.
5. **Utiliser des noms descriptifs** - `devrait lever NotFoundException quand...`
6. **Remplacer PermissionGuard dans les tests de contrôleur** - Il dépend de DataSource, donc il faut le mocker
7. **Utiliser `flushPromises`** - Pour tester les opérations asynchrones fire-and-forget
