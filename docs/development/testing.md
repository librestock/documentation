# Testing

The LibreStock Inventory backend uses Vitest for testing and Playwright for frontend E2E tests.

## Overview

| Module | Framework | Status |
|--------|-----------|--------|
| Backend | Vitest | Active |
| Frontend | Playwright | Active |

## Running Tests

### Backend Tests

```bash
# Run all tests
pnpm --filter @librestock/api test

# Run tests in watch mode
pnpm --filter @librestock/api test:watch

# Run tests with coverage
pnpm --filter @librestock/api test:cov

# Run integration tests
pnpm --filter @librestock/api test:integration

# Run a specific test file
pnpm --filter @librestock/api test -- products
```

### Frontend Tests

```bash
# Run Playwright E2E tests
cd frontend
pnpm test:e2e
```

## Test Structure

### Backend Unit Tests

Located alongside source files as `*.spec.ts` or `*.test.ts`:

```
backend/src/effect/modules/products/
├── service.ts
├── service.test.ts          # Unit tests
├── repository.ts
└── ...
```

### Backend Integration Tests

Located with a separate Vitest config:

```bash
pnpm --filter @librestock/api test:integration
```

## Writing Unit Tests

### Service Test Pattern

Effect services are tested by providing mock layers for dependencies:

```typescript
import { describe, it, expect } from "vitest";
import { Effect, Layer } from "effect";
import { ProductsService } from "./service";
import { ProductsRepository } from "./repository";

describe("ProductsService", () => {
  // Mock data
  const mockProduct = {
    id: "660e8400-e29b-41d4-a716-446655440000",
    sku: "PROD-001",
    name: "Test Product",
    category_id: null,
    is_active: true,
  };

  // Create a mock repository layer
  const MockProductsRepository = Layer.succeed(ProductsRepository, {
    findById: (id: string) => Effect.succeed(mockProduct),
    findBySku: (sku: string) => Effect.succeed(null),
    create: (data: any) => Effect.succeed({ ...mockProduct, ...data }),
    // ... other methods
  });

  // Build test layer with all dependencies
  const TestLayer = ProductsService.Default.pipe(
    Layer.provide(MockProductsRepository),
    // ... other mock layers
  );

  it("should return a product by id", async () => {
    const result = await Effect.gen(function* () {
      const service = yield* ProductsService;
      return yield* service.findOne("some-id");
    }).pipe(Effect.provide(TestLayer), Effect.runPromise);

    expect(result.id).toBe(mockProduct.id);
    expect(result.sku).toBe("PROD-001");
  });

  it("should fail with ProductNotFound for invalid id", async () => {
    const EmptyRepo = Layer.succeed(ProductsRepository, {
      findById: () => Effect.succeed(null),
      // ... other methods
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

### Testing Error Cases

Use `Effect.either` to catch expected failures:

```typescript
it("should fail when SKU already exists", async () => {
  const RepoWithExisting = Layer.succeed(ProductsRepository, {
    findBySku: () => Effect.succeed(mockProduct),
    // ... other methods
  });

  const layer = ProductsService.Default.pipe(Layer.provide(RepoWithExisting));

  const result = await Effect.gen(function* () {
    const service = yield* ProductsService;
    return yield* service.create({ sku: "PROD-001", name: "Duplicate" }, "user-id");
  }).pipe(Effect.provide(layer), Effect.either, Effect.runPromise);

  expect(result._tag).toBe("Left");
});
```

### Testing with Real Database (Integration)

Integration tests use a real database connection:

```typescript
import { describe, it, expect, beforeAll, afterAll } from "vitest";
import { Effect, Layer } from "effect";

describe("ProductsService (integration)", () => {
  // Use the real Drizzle layer with a test database
  const TestLayer = ProductsService.Default.pipe(
    Layer.provide(drizzleTestLayer),
  );

  it("should create and retrieve a product", async () => {
    const result = await Effect.gen(function* () {
      const service = yield* ProductsService;
      const created = yield* service.create(
        { sku: "INT-001", name: "Integration Test Product" },
        "test-user-id"
      );
      return yield* service.findOne(created.id);
    }).pipe(Effect.provide(TestLayer), Effect.runPromise);

    expect(result.sku).toBe("INT-001");
  });
});
```

## Testing Patterns

### Mocking Effect Services

Create mock implementations using `Layer.succeed`:

```typescript
// Provide a simple mock
const MockCategoriesService = Layer.succeed(CategoriesService, {
  existsById: (id: string) => Effect.succeed(true),
  findAll: () => Effect.succeed([]),
});

// Combine mock layers
const TestLayer = ProductsService.Default.pipe(
  Layer.provide(MockProductsRepository),
  Layer.provide(MockCategoriesService),
);
```

### Testing Fire-and-Forget Operations

Audit logging uses `Effect.forkDaemon` (fire-and-forget). To test that audit logs are written:

```typescript
it("should write audit log on create", async () => {
  const auditCalls: any[] = [];

  const MockAudit = Layer.succeed(AuditLogWriter, {
    log: (entry: any) => {
      auditCalls.push(entry);
      return Effect.void;
    },
  });

  // ... run the effect with MockAudit in the layer

  // Allow daemon fibers to complete
  await new Promise((resolve) => setTimeout(resolve, 10));

  expect(auditCalls).toHaveLength(1);
  expect(auditCalls[0].action).toBe("CREATE");
});
```

## Coverage

Generate coverage report:

```bash
pnpm --filter @librestock/api test:cov
```

Coverage reports are generated in `backend/coverage/`.

## Best Practices

1. **Use `Layer.succeed` for mocks** — Provides type-safe mock implementations for Effect services
2. **Use `Effect.either` for error testing** — Catches expected failures without throwing
3. **Isolate tests** — Each test should provide its own layers and not share mutable state
4. **Prefer integration tests for workflows** — Mock boundaries, not neighbors; test cross-module logic against a real database
5. **Use `Effect.runPromise`** — Converts Effect to a promise for Vitest's async test runner
6. **Test error types explicitly** — Verify the specific error class, not just that it failed
7. **Keep mocks minimal** — Only mock the methods the test actually exercises
