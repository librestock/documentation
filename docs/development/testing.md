# Testing

The LibreStock Inventory system uses Jest for backend testing. This guide covers test patterns and best practices.

## Overview

| Module | Framework | Status |
|--------|-----------|--------|
| Backend | Jest 30 + ts-jest | Active |
| Frontend | - | Planned |

## Running Tests

### Backend Tests

```bash
# Run all unit tests
pnpm --filter @librestock/api test

# Run tests in watch mode
pnpm --filter @librestock/api test:watch

# Run tests with coverage
pnpm --filter @librestock/api test:cov

# Run end-to-end tests
pnpm --filter @librestock/api test:e2e

# Run a specific test file (Jest 30 uses --testPathPatterns, plural)
pnpm --filter @librestock/api test -- --testPathPatterns products
```

!!! warning "Jest 30 flag"
    Jest 30 uses `--testPathPatterns` (plural), not `--testPathPattern`. Using the singular form will silently fail.

## Test Structure

### Unit Tests

Located alongside source files as `*.spec.ts`:

```
backend/src/routes/products/
├── products.service.ts
├── products.service.spec.ts    # Unit tests
├── products.controller.ts
└── ...
```

### E2E Tests

Located in `backend/test/`:

```
backend/test/
├── products.e2e-spec.ts
├── categories.e2e-spec.ts
└── jest-e2e.json
```

## Writing Unit Tests

### Service Test Pattern

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { ProductsService } from './products.service';
import { ProductRepository } from './product.repository';

describe('ProductsService', () => {
  let service: ProductsService;
  let productRepository: jest.Mocked<ProductRepository>;

  // Mock data
  const mockProduct = {
    id: '660e8400-e29b-41d4-a716-446655440000',
    sku: 'PROD-001',
    name: 'Test Product',
    // ... other fields
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
            update: jest.fn(),
            softDelete: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<ProductsService>(ProductsService);
    productRepository = module.get(ProductRepository);
  });

  describe('findOne', () => {
    it('should return a product', async () => {
      productRepository.findById.mockResolvedValue(mockProduct);

      const result = await service.findOne('some-id');

      expect(result).toEqual(mockProduct);
      expect(productRepository.findById).toHaveBeenCalledWith('some-id');
    });

    it('should throw NotFoundException when product not found', async () => {
      productRepository.findById.mockResolvedValue(null);

      await expect(service.findOne('invalid-id'))
        .rejects.toThrow(NotFoundException);
    });
  });
});
```

### Controller Test Pattern

When testing controllers, override `PermissionGuard` (not the auth guard) because `PermissionGuard` depends on `DataSource`:

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

### Mocking Repositories

Create mock objects with all methods:

```typescript
const mockProductRepository = {
  findAllPaginated: jest.fn(),
  findAll: jest.fn(),
  findById: jest.fn(),
  findBySku: jest.fn(),
  create: jest.fn(),
  update: jest.fn(),
  softDelete: jest.fn(),
  restore: jest.fn(),
};
```

## Writing E2E Tests

### Setup Pattern

E2E tests override the `AuthGuard` to mock authentication:

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';
import { AuthGuard } from '../src/common/auth/auth.guard';

describe('ProductsController (e2e)', () => {
  let app: INestApplication;
  let productRepository: Repository<Product>;

  // Mock auth guard
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

    productRepository = moduleFixture.get(getRepositoryToken(Product));
  });

  afterAll(async () => {
    await app.close();
  });

  beforeEach(async () => {
    // Clean database
    await productRepository.query('DELETE FROM products');
  });

  describe('GET /api/v1/products', () => {
    it('should return paginated products', async () => {
      // Create test data
      await productRepository.save({ sku: 'TEST-001', name: 'Test' });

      const response = await request(app.getHttpServer())
        .get('/api/v1/products')
        .set('Authorization', 'Bearer token')
        .expect(200);

      expect(response.body.data).toHaveLength(1);
      expect(response.body.meta.total).toBe(1);
    });
  });
});
```

## Test Utilities

### Creating Test Data

```typescript
const createTestProduct = async (overrides = {}) => {
  return productRepository.save({
    sku: 'TEST-SKU-001',
    name: 'Test Product',
    category_id: testCategory.id,
    reorder_point: 10,
    is_active: true,
    is_perishable: false,
    ...overrides,
  });
};
```

### Testing Async Fire-and-Forget Operations

Use the `flushPromises` pattern for testing async operations that are fire-and-forget (e.g., audit logging):

```typescript
const flushPromises = () =>
  new Promise((resolve) => setImmediate(resolve));

it('should create audit log', async () => {
  interceptor.intercept(mockContext, mockHandler).subscribe();

  await flushPromises();

  expect(auditLogService.log).toHaveBeenCalled();
});
```

## Coverage

Generate coverage report:

```bash
pnpm --filter @librestock/api test:cov
```

Coverage reports are generated in `backend/coverage/`.

## Best Practices

1. **Isolate tests** - Each test should be independent
2. **Mock external dependencies** - Database, APIs, etc.
3. **Clean up after tests** - Use `beforeEach`/`afterEach`
4. **Test edge cases** - Error conditions, empty data, etc.
5. **Use descriptive names** - `should throw NotFoundException when...`
6. **Override PermissionGuard in controller tests** - It depends on DataSource, so mock it
7. **Use `flushPromises`** - For testing fire-and-forget async operations
