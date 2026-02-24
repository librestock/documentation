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

Les contrôleurs utilisent `@Controller()` avec une chaîne vide. Le routage est fait via `RouterModule` dans `app.routes.ts`.

```typescript
// products.controller.ts
@Controller()
@ApiTags('Products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Post()
  @Auditable()
  @RequirePermission('products', 'create')
  @StandardThrottle()
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

!!! note "Routage des contrôleurs"
    Les contrôleurs utilisent `@Controller()` avec une chaîne vide. Les chemins de routes réels (ex: `/products`) sont configurés via `RouterModule` dans `app.routes.ts`. Le préfixe global `/api/v1` est appliqué automatiquement.

### Décorateurs clés

| Décorateur | Objectif | Exemple |
|------------|----------|---------|
| `@Auditable()` | Enregistre l'action dans le journal d'audit | `@Auditable()` |
| `@RequirePermission(resource, permission)` | Applique la vérification de permission | `@RequirePermission('products', 'create')` |
| `@StandardThrottle()` | Limitation de débit (100 req/min) | `@StandardThrottle()` |
| `@Transactional()` | Encapsule la méthode dans une transaction DB | `@Transactional()` |

### 6. Liens HATEOAS

Les liens HATEOAS utilisent des chemins relatifs. Le `HateoasInterceptor` préfixe automatiquement le préfixe global (`/api/v1`).

```typescript
// products.hateoas.ts
export const PRODUCT_HATEOAS_LINKS: LinkDefinition[] = [
  { rel: 'self', href: (data) => `/products/${data.id}`, method: 'GET' },
  { rel: 'update', href: (data) => `/products/${data.id}`, method: 'PUT' },
  { rel: 'delete', href: (data) => `/products/${data.id}`, method: 'DELETE' },
];

export const ProductHateoas = () => HateoasLinks(...PRODUCT_HATEOAS_LINKS);
```

### 7. Enregistrement du module

```typescript
// products.module.ts
@Module({
  imports: [TypeOrmModule.forFeature([Product])],
  controllers: [ProductsController],
  providers: [ProductsService, ProductRepository],
  exports: [ProductsService],
})
export class ProductsModule {}
```

!!! tip "N'exporter que le Service"
    Les modules n'exportent que leur Service, jamais le Repository. L'accès inter-modules passe par la couche Service.

### 8. Mise à jour des types partagés

```bash
pnpm --filter @librestock/types barrels
pnpm --filter @librestock/types build
```

## Authentification

### Utilisation des guards

L'authentification est gérée par Better Auth via `AuthGuard` :

```typescript
// AuthGuard est appliqué globalement -- pas besoin de l'ajouter par contrôleur
// Utiliser @RequirePermission pour l'autorisation
@Controller()
export class ProductsController {
  @RequirePermission('products', 'read')
  @Get()
  async findAll() { ... }
}
```

### Accès à l'utilisateur

```typescript
// Obtenir l'ID utilisateur
@CurrentUser('userId') userId: string

// Obtenir l'objet auth complet
@CurrentUser() auth: { userId: string; sessionId: string }
```

## Autorisation

Utiliser `@RequirePermission` pour appliquer le contrôle d'accès basé sur les permissions :

```typescript
@Controller()
export class ProductsController {
  @RequirePermission('products', 'read')
  @Get()
  async findAll() { ... }

  @RequirePermission('products', 'create')
  @Post()
  async create() { ... }

  @RequirePermission('products', 'update')
  @Put(':id')
  async update() { ... }

  @RequirePermission('products', 'delete')
  @Delete(':id')
  async remove() { ... }
}
```

Le `PermissionGuard` vérifie les permissions du rôle de l'utilisateur par rapport à la permission requise déclarée par `@RequirePermission`.

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
    "self": { "href": "/api/v1/products/uuid", "method": "GET" }
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

## Limitation de débit

L'API utilise `@nestjs/throttler` pour la limitation de débit par IP.

### Décorateurs de throttle

Appliquer aux contrôleurs ou aux endpoints individuels :

```typescript
import { StandardThrottle, BulkThrottle, AuthThrottle } from 'src/common/decorators/throttle.decorator';

@StandardThrottle() // 100 req/min
@Controller()
export class ProductsController {

  @BulkThrottle() // Remplace avec 20 req/min
  @Post('bulk')
  async bulkCreate() { ... }
}

@AuthThrottle() // 10 req/min pour les endpoints d'authentification
@Controller()
export class AuthController { ... }
```

### Niveaux de throttle disponibles

- `@StandardThrottle()` - 100 requêtes/minute (défaut pour la plupart des endpoints)
- `@BulkThrottle()` - 20 requêtes/minute (opérations en masse)
- `@AuthThrottle()` - 10 requêtes/minute (prévient le brute force)
- `@SkipThrottle()` - Pas de limitation (health checks)

## Gestion des transactions

Utiliser le décorateur `@Transactional()` pour les opérations atomiques.

### Utilisation basique

```typescript
import { Transactional } from 'src/common/decorators/transactional.decorator';

@Injectable()
export class ProductsService {
  @Transactional()
  async bulkCreate(dto: BulkCreateProductsDto) {
    // Toutes les opérations DB ici s'exécutent dans une transaction
    // Si une opération échoue, tous les changements sont annulés automatiquement

    for (const product of dto.products) {
      await this.productRepository.create(product);
    }

    return result;
  }
}
```

### Quand utiliser les transactions

Utiliser `@Transactional()` pour les opérations qui :

1. **Modifient plusieurs enregistrements** - Assurer la sémantique tout-ou-rien
2. **Ont des dépendances** - Empêcher l'achèvement partiel (ex: création d'inventaire)
3. **Mettent à jour des hiérarchies** - Protéger les relations parent-enfant
4. **Ajustent des quantités** - Empêcher les conditions de course
5. **Opérations en masse** - Empêcher les insertions partielles

### Comportement des transactions

- **Succès** : Tous les changements validés en base de données
- **Erreur** : Tous les changements annulés automatiquement
- **Journalisation** : Début et fin/annulation journalisés automatiquement
- **Imbrication** : Les transactions peuvent être imbriquées (utilise des savepoints)
- **Performance** : ~5-10ms de surcharge par transaction

## Journalisation d'audit

Utiliser le décorateur `@Auditable()` pour enregistrer automatiquement les modifications d'entités :

```typescript
@Post()
@Auditable()
@RequirePermission('products', 'create')
async create(@Body() dto: CreateProductDto) {
  return this.productsService.create(dto);
}
```

Le journal d'audit capture l'action, l'utilisateur, l'entité et l'horodatage.

## Health Checks

L'API fournit trois endpoints de vérification de santé via `@nestjs/terminus`.

### Endpoints

#### Vérification complète

`GET /health-check`

Vérifie la connectivité à la base de données et la configuration de l'authentification :

```json
{
  "status": "ok",
  "info": {
    "database": { "status": "up" },
    "auth": {
      "status": "up",
      "message": "Better Auth is properly configured"
    }
  }
}
```

Retourne `503` si une vérification échoue.

#### Sonde de vivacité

`GET /health-check/live`

Sonde de vivacité Kubernetes - retourne toujours `200` si l'application tourne :

```json
{
  "status": "ok"
}
```

#### Sonde de disponibilité

`GET /health-check/ready`

Sonde de disponibilité Kubernetes - vérifie uniquement la base de données :

```json
{
  "status": "ok",
  "info": {
    "database": { "status": "up" }
  }
}
```

Retourne `503` si la base de données est inaccessible.

### Configuration Kubernetes

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
