# API Development

This guide covers NestJS development patterns for the LibreStock Inventory backend.

## Module Structure

Each feature follows this structure:

```
routes/<feature>/
├── <feature>.module.ts
├── <feature>.controller.ts
├── <feature>.service.ts
├── <feature>.repository.ts
├── <feature>.hateoas.ts
├── entities/
│   └── <feature>.entity.ts
└── dto/
    ├── create-<feature>.dto.ts
    ├── update-<feature>.dto.ts
    ├── <feature>-response.dto.ts
    ├── <feature>-query.dto.ts
    └── index.ts
```

## Creating a New Entity

### 1. Entity Definition

```typescript
// routes/products/entities/product.entity.ts
import { Entity, Column, ManyToOne, JoinColumn } from 'typeorm';
import { BaseAuditEntity } from 'src/common/entities/base-audit.entity';
import { Category } from '../../categories/entities/category.entity';

@Entity('products')
export class Product extends BaseAuditEntity {
  @Column({ length: 50, unique: true })
  sku: string;

  @Column({ length: 200 })
  name: string;

  @Column({ type: 'uuid', nullable: true })
  category_id: string | null;

  @ManyToOne(() => Category, { onDelete: 'RESTRICT' })
  @JoinColumn({ name: 'category_id' })
  category: Category | null;
}
```

### Base Entities

- `BaseEntity`: `created_at`, `updated_at`
- `BaseAuditEntity`: Adds `deleted_at`, `created_by`, `updated_by`, `deleted_by`

### 2. DTOs

```typescript
// dto/create-product.dto.ts
import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsUUID, IsOptional, MaxLength } from 'class-validator';

export class CreateProductDto {
  @ApiProperty({ example: 'PROD-001' })
  @IsString()
  @MaxLength(50)
  sku: string;

  @ApiProperty({ example: 'Luxury Towel' })
  @IsString()
  @MaxLength(200)
  name: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsUUID()
  category_id?: string;
}
```

### 3. Repository

```typescript
// product.repository.ts
@Injectable()
export class ProductRepository {
  constructor(
    @InjectRepository(Product)
    private readonly repository: Repository<Product>,
  ) {}

  async findById(id: string): Promise<Product | null> {
    return this.repository.findOne({
      where: { id, deleted_at: IsNull() },
      relations: ['category'],
    });
  }

  async create(data: Partial<Product>): Promise<Product> {
    const product = this.repository.create(data);
    return this.repository.save(product);
  }
}
```

### 4. Service

```typescript
// products.service.ts
@Injectable()
export class ProductsService {
  constructor(
    private readonly productRepository: ProductRepository,
    private readonly categoryRepository: CategoryRepository,
  ) {}

  async create(dto: CreateProductDto, userId: string): Promise<Product> {
    // Validate category exists
    if (dto.category_id) {
      const exists = await this.categoryRepository.existsById(dto.category_id);
      if (!exists) {
        throw new NotFoundException('Category not found');
      }
    }

    // Check SKU uniqueness
    const existing = await this.productRepository.findBySku(dto.sku);
    if (existing) {
      throw new BadRequestException('SKU already exists');
    }

    return this.productRepository.create({
      ...dto,
      created_by: userId,
      updated_by: userId,
    });
  }
}
```

### 5. Controller

```typescript
// products.controller.ts
@Controller('products')
@UseGuards(ClerkAuthGuard)
@ApiTags('Products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Post()
  @UseInterceptors(HateoasInterceptor)
  @ProductHateoas()
  @ApiOperation({ summary: 'Create product' })
  @ApiResponse({ status: 201, type: ProductResponseDto })
  async create(
    @Body() dto: CreateProductDto,
    @CurrentUser('userId') userId: string,
  ): Promise<Product> {
    return this.productsService.create(dto, userId);
  }
}
```

### 6. HATEOAS Links

```typescript
// products.hateoas.ts
export const PRODUCT_HATEOAS_LINKS: LinkDefinition[] = [
  { rel: 'self', href: (data) => `/products/${data.id}`, method: 'GET' },
  { rel: 'update', href: (data) => `/products/${data.id}`, method: 'PUT' },
  { rel: 'delete', href: (data) => `/products/${data.id}`, method: 'DELETE' },
];

export const ProductHateoas = () => HateoasLinks(...PRODUCT_HATEOAS_LINKS);
```

### 7. Module Registration

```typescript
// products.module.ts
@Module({
  imports: [TypeOrmModule.forFeature([Product])],
  controllers: [ProductsController],
  providers: [ProductsService, ProductRepository],
  exports: [ProductsService],
})
export class ProductsModule {}

// Register in app.module.ts
@Module({
  imports: [
    // ...
    ProductsModule,
  ],
})
export class AppModule {}
```

### 8. Update Shared Types

```bash
pnpm --filter @librestock/types build
```

## Authentication

### Using Guards

```typescript
@Controller('products')
@UseGuards(ClerkAuthGuard)
export class ProductsController {}
```

### Accessing User

```typescript
// Get user ID
@CurrentUser('userId') userId: string

// Get full auth object
@CurrentUser() auth: { userId: string; sessionId: string }

// Get JWT claims
@ClerkClaims() claims: JwtPayload
```

## Error Handling

Use NestJS built-in exceptions:

```typescript
throw new NotFoundException('Product not found');
throw new BadRequestException('Invalid SKU format');
throw new UnauthorizedException('Token expired');
throw new ForbiddenException('Insufficient permissions');
```

## Soft Delete

Products use soft delete:

```typescript
// Repository - exclude deleted by default
async findAll(): Promise<Product[]> {
  return this.repository.find({
    where: { deleted_at: IsNull() },
  });
}

// Include deleted
async findAllWithDeleted(): Promise<Product[]> {
  return this.repository.find();
}

// Soft delete
async softDelete(id: string, userId: string): Promise<void> {
  await this.repository.update(id, {
    deleted_at: new Date(),
    deleted_by: userId,
  });
}
```

## Response Formats

### Single Entity

```json
{
  "id": "uuid",
  "name": "Product Name",
  "_links": {
    "self": { "href": "/products/uuid", "method": "GET" }
  }
}
```

### Paginated List

```json
{
  "data": [...],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "total_pages": 5,
    "has_next": true,
    "has_previous": false
  }
}
```

### Bulk Operation

```json
{
  "success_count": 8,
  "failure_count": 2,
  "succeeded": ["id1", "id2"],
  "failures": [
    { "id": "id3", "error": "Not found" }
  ]
}
```

## Rate Limiting

The API uses `@nestjs/throttler` for IP-based rate limiting.

### Throttle Decorators

Apply to controllers or individual endpoints:

```typescript
import { StandardThrottle, BulkThrottle, AuthThrottle } from 'src/common/decorators/throttle.decorator';

@StandardThrottle() // 100 req/min
@Controller('products')
export class ProductsController {

  @BulkThrottle() // Override with 20 req/min
  @Post('bulk')
  async bulkCreate() { ... }
}

@AuthThrottle() // 10 req/min for auth endpoints
@Controller('auth')
export class AuthController { ... }
```

### Available Throttle Levels

- `@StandardThrottle()` - 100 requests/minute (default for most endpoints)
- `@BulkThrottle()` - 20 requests/minute (bulk operations)
- `@AuthThrottle()` - 10 requests/minute (prevents brute force)
- `@SkipThrottle()` - No rate limiting (health checks)

### 429 Response

When rate limited:

```json
{
  "statusCode": 429,
  "error": "Too Many Requests",
  "message": "Rate limit exceeded. Please slow down your requests and try again later.",
  "path": "/api/v1/products",
  "timestamp": "2026-01-18T20:00:00.000Z",
  "hint": "Consider implementing exponential backoff or waiting before retrying."
}
```

## Transaction Management

Use the `@Transactional()` decorator for atomic operations.

### Basic Usage

```typescript
import { Transactional } from 'src/common/decorators/transactional.decorator';

@Injectable()
export class ProductsService {
  @Transactional()
  async bulkCreate(dto: BulkCreateProductsDto) {
    // All database operations here run in a transaction
    // If any operation fails, all changes are rolled back automatically

    for (const product of dto.products) {
      await this.productRepository.create(product);
    }

    return result;
  }
}
```

### When to Use Transactions

Use `@Transactional()` for operations that:

1. **Modify multiple records** - Ensure all-or-nothing semantics
2. **Have dependencies** - Prevent partial completion (e.g., inventory creation)
3. **Update hierarchies** - Protect parent-child relationships
4. **Adjust quantities** - Prevent race conditions
5. **Bulk operations** - Prevent partial batch inserts

### Examples

```typescript
// Bulk insert - prevents partial batches
@Transactional()
async bulkCreate(products: CreateProductDto[]) {
  const created = [];
  for (const dto of products) {
    created.push(await this.repository.create(dto));
  }
  return created;
}

// Inventory creation - prevents TOCTOU races
@Transactional()
async create(dto: CreateInventoryDto) {
  // Check if inventory exists
  const existing = await this.repository.findByProductAndLocation(
    dto.product_id,
    dto.location_id
  );
  if (existing) throw new ConflictException();

  // Create inventory
  return this.repository.create(dto);
}

// Quantity adjustment - atomic updates
@Transactional()
async adjustQuantity(id: string, adjustment: number) {
  const inventory = await this.repository.findById(id);
  const newQuantity = inventory.quantity + adjustment;

  if (newQuantity < 0) {
    throw new BadRequestException('Insufficient quantity');
  }

  await this.repository.update(id, { quantity: newQuantity });
  return this.repository.findById(id);
}

// Circular reference check - atomic validation
@Transactional()
async update(id: string, dto: UpdateCategoryDto) {
  if (dto.parent_id) {
    await this.validateNoCircularReference(id, dto.parent_id);
  }
  return this.repository.update(id, dto);
}
```

### Transaction Behavior

- **Success**: All changes committed to database
- **Error**: All changes rolled back automatically
- **Logging**: Start and completion/rollback logged automatically
- **Nesting**: Transactions can be nested (uses savepoints)
- **Performance**: ~5-10ms overhead per transaction

## Enhanced Error Handling

Authentication errors include detailed type information.

### Clerk Error Classification

The `ClerkAuthGuard` classifies errors for better UX:

```typescript
{
  "message": "Your session has expired. Please sign in again.",
  "error_type": "token_expired",
  "retryable": false
}
```

### Error Types

| Type | Description | Retryable | User Action |
|------|-------------|-----------|-------------|
| `token_expired` | Session has expired | No | Re-authenticate |
| `token_invalid` | Malformed/invalid token | No | Re-authenticate |
| `token_missing` | No auth header provided | No | Provide token |
| `network_error` | Clerk service unavailable | Yes | Retry request |
| `configuration_error` | Server misconfigured | No | Contact support |
| `unknown_error` | Other errors | Yes | Retry or contact support |

### Frontend Integration

```typescript
try {
  await api.getProducts();
} catch (error) {
  if (error.error_type === 'token_expired') {
    // Redirect to login
    router.push('/login');
  } else if (error.retryable) {
    // Implement retry logic with exponential backoff
    await retryWithBackoff(() => api.getProducts());
  } else {
    // Show error message
    toast.error(error.message);
  }
}
```

### Error Logging

Full error details are logged server-side for debugging:

```
[WARN] Authentication failed: token_expired - TokenExpiredError: jwt expired
  path: /api/v1/products
  method: GET
  errorType: token_expired
```

## Health Checks

The API provides three health check endpoints using `@nestjs/terminus`.

### Endpoints

#### Full Health Check

`GET /health-check`

Checks database connectivity and Clerk configuration:

```json
{
  "status": "ok",
  "info": {
    "database": { "status": "up" },
    "clerk": {
      "status": "up",
      "message": "Clerk is properly configured",
      "environment": "test"
    }
  }
}
```

Returns `503` if any check fails.

#### Liveness Probe

`GET /health-check/live`

Kubernetes liveness probe - always returns `200` if app is running:

```json
{
  "status": "ok"
}
```

#### Readiness Probe

`GET /health-check/ready`

Kubernetes readiness probe - checks database only:

```json
{
  "status": "ok",
  "info": {
    "database": { "status": "up" }
  }
}
```

Returns `503` if database is unreachable.

### Custom Health Indicators

The Clerk health indicator validates configuration:

```typescript
// routes/health/indicators/clerk-health.indicator.ts
@Injectable()
export class ClerkHealthIndicator extends HealthIndicator {
  async isHealthy(key: string): Promise<HealthIndicatorResult> {
    const secretKey = this.configService.get<string>('CLERK_SECRET_KEY');

    if (!secretKey) {
      throw new HealthCheckError('Clerk not configured', ...);
    }

    const isValid = secretKey.startsWith('sk_test_') ||
                    secretKey.startsWith('sk_live_');

    return this.getStatus(key, isValid, {
      message: 'Clerk is properly configured',
      environment: secretKey.startsWith('sk_test_') ? 'test' : 'live'
    });
  }
}
```

### Kubernetes Configuration

```yaml
livenessProbe:
  httpGet:
    path: /health-check/live
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /health-check/ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```
