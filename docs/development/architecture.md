# Architecture

## System Overview

```mermaid
graph TB
    subgraph "Frontend"
        A[TanStack Start] --> B[React 19]
        A --> E[TanStack Router]
        B --> C[TanStack Query]
        B --> D[TanStack Form]
    end

    subgraph "Backend"
        F[Effect.ts + Bun] --> G[Drizzle ORM]
        G --> H[(PostgreSQL 16)]
    end

    subgraph "Auth"
        I[Better Auth]
    end

    A -->|REST API| F
    A --> I
    F --> I
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | TanStack Start, React 19, TanStack Router, TanStack Query/Form, Tailwind CSS 4, Radix UI |
| Backend | Effect.ts, Drizzle ORM, Bun, PostgreSQL 16 |
| Auth | Better Auth |
| API Docs | Effect HttpApi (OpenAPI) |
| Tooling | pnpm workspaces, Nix flakes, TypeScript, Docker Compose |
| i18n | i18next (en, de, fr) |

## Repository Structure

```
librestock/
├── backend/                # Effect.ts backend (Bun runtime)
│   ├── src/
│   │   └── effect/
│   │       ├── modules/    # Feature modules
│   │       ├── platform/   # Cross-cutting concerns
│   │       └── http/       # HTTP app & middleware
│   └── flake.nix           # Nix dev environment
├── frontend/               # TanStack Start frontend
│   ├── src/
│   │   ├── routes/         # File-based routes
│   │   ├── components/     # React components
│   │   └── lib/            # Utilities and data hooks
│   └── flake.nix           # Nix dev environment
├── packages/
│   ├── tsconfig/           # Shared TS configs
│   ├── eslint-config/      # Shared ESLint config
│   └── types/              # Shared DTO interfaces/enums
├── documentation/          # MkDocs documentation
└── meta/                   # Orchestration scripts, Docker Compose
```

## Data Flow

```
┌─────────────────────────────────────────┐
│           TanStack Start Frontend       │
│  React Query + handwritten clients       │
│  Shared DTOs from @librestock/types      │
│  Better Auth                             │
└─────────────────────────────────────────┘
                    ▼ HTTP/REST
┌─────────────────────────────────────────┐
│          Effect.ts Backend (Bun)        │
│  Router → Service → Repository          │
│  requireSession · requirePermission     │
│  Drizzle ORM · HATEOAS · Audit Logging  │
└─────────────────────────────────────────┘
                    ▼
┌─────────────────────────────────────────┐
│             PostgreSQL                  │
└─────────────────────────────────────────┘
```

## Authentication Flow

```
User → Better Auth → Session Cookie
                       ↓
Frontend: Cookie-based session
                       ↓
Backend: requireSession → verify → userId from session
```

## Backend Route Modules

The backend has the following modules in `backend/src/effect/modules/`:

| Module | Purpose |
|--------|---------|
| **areas** | Zones within locations (shelves, bins, etc.) |
| **audit-logs** | Audit trail for all entity changes |
| **auth** | Authentication endpoints (Better Auth) |
| **branding** | Branding/customization settings |
| **categories** | Hierarchical product categorization |
| **clients** | Client/customer management |
| **health** | Health check endpoints (liveness, readiness) |
| **inventory** | Stock quantities at locations/areas |
| **locations** | Physical locations (warehouses, etc.) |
| **orders** | Order management |
| **photos** | Photo/image management for products |
| **products** | Product catalog (SKU, name, category) |
| **roles** | Role and permission management |
| **stock-movements** | Stock movement tracking (transfers, adjustments) |
| **suppliers** | Supplier management |
| **users** | User management |

## Backend Platform Layer

Shared infrastructure in `backend/src/effect/platform/`:

| Directory / File | Purpose |
|------------------|---------|
| **authorization.ts** | `requirePermission(resource, permission)` Effect |
| **permission-provider.ts** | Cached permission lookups (1-min TTL) |
| **session.ts** | `requireSession`, `getOptionalSession` Effects |
| **better-auth.ts** | Better Auth integration (admin APIs) |
| **errors.ts** | Domain error factories (`NotFoundError`, `BadRequestError`, etc.) |
| **messages.ts** | Localized message system (en, fr, de) |
| **audit.ts** | Fire-and-forget audit log writer |
| **drizzle.ts** | Drizzle ORM database layer with connection pooling |
| **hateoas.ts** | HATEOAS link utilities |
| **request-context.ts** | Request ID, path, method, IP, locale |
| **db/** | Schema definitions, relations, migrations |

## Shared-Types Workflow

Shared DTO interfaces/enums are the contract between frontend and backend:

```bash
# 1. Generate barrel exports
pnpm --filter @librestock/types barrels

# 2. Build shared types
pnpm --filter @librestock/types build
```

!!! warning "Keep shared types aligned"
    Ensure backend DTOs and frontend hooks match `packages/types`.

## Domain Model

```mermaid
classDiagram
    class Product {
        +uuid id
        +string sku
        +string name
        +uuid category_id
        +int reorder_point
    }

    class Location {
        +uuid id
        +string name
        +LocationType type
    }

    class Area {
        +uuid id
        +uuid location_id
        +uuid parent_id
        +string name
        +string code
    }

    class Inventory {
        +uuid id
        +uuid product_id
        +uuid location_id
        +uuid area_id
        +int quantity
    }

    class Category {
        +uuid id
        +string name
        +uuid parent_id
    }

    class Client {
        +uuid id
        +string name
    }

    class Supplier {
        +uuid id
        +string name
    }

    class Order {
        +uuid id
        +uuid client_id
        +OrderStatus status
    }

    class StockMovement {
        +uuid id
        +uuid product_id
        +uuid from_location_id
        +uuid to_location_id
        +int quantity
    }

    class Role {
        +uuid id
        +string name
        +Permission[] permissions
    }

    class User {
        +uuid id
        +string email
        +uuid role_id
    }

    Product --> Category : belongs to
    Product --> Inventory : tracked in
    Location --> Inventory : stores
    Location --> Area : contains
    Area --> Area : parent/children
    Area --> Inventory : specifies placement
    Order --> Client : placed by
    Supplier --> Product : supplies
    StockMovement --> Product : moves
    StockMovement --> Location : from/to
    User --> Role : has
```

### Core Entities

| Entity | Purpose |
|--------|---------|
| **Product** | Catalog item (what) - SKU, name, category, reorder point |
| **Category** | Hierarchical product organization |
| **Location** | Physical place (where) - warehouse, supplier, client, in-transit |
| **Area** | Zone within a location (where exactly) - shelf, bin, cold storage |
| **Inventory** | Stock quantity (how many) of a product at a location/area |
| **Client** | Customer who places orders |
| **Supplier** | External supplier providing products |
| **Order** | Customer order for products |
| **StockMovement** | Record of stock transfers, adjustments, and movements |
| **Role** | Named set of permissions for authorization |
| **User** | System user with assigned role |
| **Photo** | Image associated with a product |
| **AuditLog** | Record of entity changes for audit trail |

### Design Decisions

1. **Product vs Inventory separation** - Products define what an item is. Inventory tracks quantities at locations.
2. **Location types** - `WAREHOUSE`, `SUPPLIER`, `IN_TRANSIT`, `CLIENT` describe the category of place.
3. **Areas are optional** - Inventory can reference just a Location, or optionally an Area for precise tracking.
4. **Area hierarchy** - Areas support parent-child relationships (Zone A -> Shelf A1 -> Bin A1-1).
5. **Unique constraint** - One inventory record per (product, location, area) combination.
6. **Permission-based auth** - Roles contain granular permissions; `requirePermission` Effect enforces access per endpoint.

## Key Patterns

| Pattern | Location | Purpose |
|---------|----------|---------|
| Repository | `backend/src/effect/modules/*/` | Data access via Drizzle ORM |
| Service | `backend/src/effect/modules/*/` | Business logic as Effect services |
| Router | `backend/src/effect/modules/*/` | HTTP route handlers |
| requireSession | `backend/src/effect/platform/` | Session verification Effect |
| requirePermission | `backend/src/effect/platform/` | Permission-based authorization |
| AuditLogWriter | `backend/src/effect/platform/` | Fire-and-forget audit logging |
| Domain Errors | `backend/src/effect/platform/` | Typed HTTP error factories |
| HATEOAS | `backend/src/effect/platform/` | REST hypermedia links |
| Layer Composition | `backend/src/effect/main.ts` | Dependency injection via Effect layers |
| Shared DTOs | `packages/types/src/` | Backend/Frontend contracts |
