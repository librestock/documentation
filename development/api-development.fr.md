# Développement API

Ce guide couvre les patterns de développement NestJS pour le backend LibreStock Inventory.

## Structure des modules

Chaque fonctionnalité suit cette structure :

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

## Créer une nouvelle entité

### 1. Définition de l'entité

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

### Entités de base

- `BaseEntity` : `created_at`, `updated_at`
- `BaseAuditEntity` : Ajoute `deleted_at`, `created_by`, `updated_by`, `deleted_by`

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

  @ApiProperty({ example: 'Serviette de luxe' })
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
    // Valider que la catégorie existe
    if (dto.category_id) {
      const exists = await this.categoryRepository.existsById(dto.category_id);
      if (!exists) {
        throw new NotFoundException('Catégorie non trouvée');
      }
    }

    // Vérifier l'unicité du SKU
    const existing = await this.productRepository.findBySku(dto.sku);
    if (existing) {
      throw new BadRequestException('Le SKU existe déjà');
    }

    return this.productRepository.create({
      ...dto,
      created_by: userId,
      updated_by: userId,
    });
  }
}
```

### 5. Contrôleur

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
  @ApiOperation({ summary: 'Créer un produit' })
  @ApiResponse({ status: 201, type: ProductResponseDto })
  async create(
    @Body() dto: CreateProductDto,
    @CurrentUser('userId') userId: string,
  ): Promise<Product> {
    return this.productsService.create(dto, userId);
  }
}
```

### 6. Mise à jour des types partagés

```bash
pnpm --filter @librestock/types build
```

## Authentification

### Utilisation des guards

```typescript
@Controller('products')
@UseGuards(ClerkAuthGuard)
export class ProductsController {}
```

### Accès à l'utilisateur

```typescript
// Obtenir l'ID utilisateur
@CurrentUser('userId') userId: string

// Obtenir l'objet auth complet
@CurrentUser() auth: { userId: string; sessionId: string }

// Obtenir les claims JWT
@ClerkClaims() claims: JwtPayload
```

## Gestion des erreurs

Utiliser les exceptions intégrées de NestJS :

```typescript
throw new NotFoundException('Produit non trouvé');
throw new BadRequestException('Format SKU invalide');
throw new UnauthorizedException('Token expiré');
throw new ForbiddenException('Permissions insuffisantes');
```

## Soft Delete

Les produits utilisent la suppression logique :

```typescript
// Repository - exclure les supprimés par défaut
async findAll(): Promise<Product[]> {
  return this.repository.find({
    where: { deleted_at: IsNull() },
  });
}

// Suppression logique
async softDelete(id: string, userId: string): Promise<void> {
  await this.repository.update(id, {
    deleted_at: new Date(),
    deleted_by: userId,
  });
}
```

## Formats de réponse

### Entité unique

```json
{
  "id": "uuid",
  "name": "Nom du produit",
  "_links": {
    "self": { "href": "/products/uuid", "method": "GET" }
  }
}
```

### Liste paginée

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
