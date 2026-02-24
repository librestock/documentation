# Roadmap

This roadmap outlines planned features and improvements for LibreStock Inventory. Items are tracked as [GitHub Issues](https://github.com/librestock/meta/issues).

!!! info "Contributing"
    Interested in contributing? Check our [contribution guidelines](contributing/guidelines.md) and pick an issue to work on!

## In Progress

### Search & Analytics

| Description | Priority |
|-------------|----------|
| Implement advanced search and filtering API | High |
| Build advanced search UI with filters | High |
| Create dashboard with inventory analytics | Medium |
| Implement inventory reporting and export features | Medium |

### Advanced Inventory

| Description | Priority |
|-------------|----------|
| Add low stock alerts and notifications | High |
| Add bulk operations for inventory management | Medium |

### User Experience

| Description | Priority |
|-------------|----------|
| Add barcode/QR code scanning support | Medium |
| Create getting started guide and seed data | Medium |

### Infrastructure & Operations

| Description | Priority |
|-------------|----------|
| Add logging and monitoring infrastructure | High |
| Set up database backup and recovery strategy | High |

## Completed

These features have been implemented:

### Core Modules

| Description | Status |
|-------------|--------|
| Products CRUD | :white_check_mark: Done |
| Categories CRUD | :white_check_mark: Done |
| Locations CRUD | :white_check_mark: Done |
| Areas CRUD | :white_check_mark: Done |
| Inventory management | :white_check_mark: Done |
| Stock Movements | :white_check_mark: Done |
| Orders management (DRAFT, CONFIRMED, SOURCING, PICKING, PACKED, SHIPPED, DELIVERED, CANCELLED, ON_HOLD) | :white_check_mark: Done |
| Clients module | :white_check_mark: Done |
| Suppliers module | :white_check_mark: Done |
| Audit logging | :white_check_mark: Done |
| Photos management | :white_check_mark: Done |

### Authentication & Authorization

| Description | Status |
|-------------|--------|
| Better Auth authentication | :white_check_mark: Done |
| Roles/Permissions system (PermissionGuard + @RequirePermission) | :white_check_mark: Done |
| Users management (admin) | :white_check_mark: Done |

### Frontend & API

| Description | Status |
|-------------|--------|
| HATEOAS REST API | :white_check_mark: Done |
| TanStack Start frontend (React 19) | :white_check_mark: Done |
| Branding/customization | :white_check_mark: Done |
| i18n (English, French, German) | :white_check_mark: Done |

### Infrastructure & Quality

| Description | Status |
|-------------|--------|
| Docker support (docker-compose) | :white_check_mark: Done |
| CI/CD (per-repo GitHub Actions) | :white_check_mark: Done |
| E2E testing (Playwright) | :white_check_mark: Done |
| Documentation site (MkDocs, GitHub Pages) | :white_check_mark: Done |
| Code quality tools and linting | :white_check_mark: Done |

## Future Considerations

Features under consideration for future releases:

- **PWA** - Progressive Web App with offline support
- **Multi-yacht support** - Manage inventory across multiple vessels
- **Supplier integration** - Direct ordering from suppliers
- **AI-powered predictions** - Automatic reorder suggestions
- **Mobile native apps** - iOS and Android applications
- **Offline-first sync** - Full offline capability with sync

## Repositories

| Repository | Description | Link |
|------------|-------------|------|
| meta | Workspace orchestration and scripts | [GitHub](https://github.com/librestock/meta) |
| backend | NestJS API server | [GitHub](https://github.com/librestock/backend) |
| frontend | TanStack Start web application | [GitHub](https://github.com/librestock/frontend) |
| packages | Shared types and utilities | [GitHub](https://github.com/librestock/packages) |
| documentation | MkDocs documentation site | [GitHub](https://github.com/librestock/documentation) |
| remote-desktop | Remote desktop tooling | [GitHub](https://github.com/librestock/remote-desktop) |
| landing | Landing page | [GitHub](https://github.com/librestock/landing) |

---

*Last updated: February 2026*
