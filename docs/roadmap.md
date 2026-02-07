# Roadmap

This roadmap outlines planned features and improvements for LibreStock Inventory. Items are tracked as [GitHub Issues](https://github.com/maximilianpw/librestock-inventory/issues).

!!! info "Contributing"
    Interested in contributing? Check our [contribution guidelines](contributing/guidelines.md) and pick an issue to work on!

## In Progress

### Core Inventory Features

| Issue | Description | Priority |
|-------|-------------|----------|
| [#39](https://github.com/maximilianpw/librestock-inventory/issues/39) | Create Inventory Items CRUD API endpoints | High |
| [#43](https://github.com/maximilianpw/librestock-inventory/issues/43) | Build Inventory Items frontend UI | High |
| [#41](https://github.com/maximilianpw/librestock-inventory/issues/41) | Create Locations/Storage Areas API | High |
| [#42](https://github.com/maximilianpw/librestock-inventory/issues/42) | Implement Suppliers management API | Medium |

### Advanced Inventory

| Issue | Description | Priority |
|-------|-------------|----------|
| [#47](https://github.com/maximilianpw/librestock-inventory/issues/47) | Implement inventory transactions/history tracking | High |
| [#48](https://github.com/maximilianpw/librestock-inventory/issues/48) | Add low stock alerts and notifications | High |
| [#54](https://github.com/maximilianpw/librestock-inventory/issues/54) | Add bulk operations for inventory management | Medium |
| [#65](https://github.com/maximilianpw/librestock-inventory/issues/65) | Add expiration date tracking for perishables | Medium |
| [#64](https://github.com/maximilianpw/librestock-inventory/issues/64) | Implement inventory ordering/requisition system | Medium |

### Search & Analytics

| Issue | Description | Priority |
|-------|-------------|----------|
| [#49](https://github.com/maximilianpw/librestock-inventory/issues/49) | Implement advanced search and filtering API | High |
| [#50](https://github.com/maximilianpw/librestock-inventory/issues/50) | Build advanced search UI with filters | High |
| [#52](https://github.com/maximilianpw/librestock-inventory/issues/52) | Create dashboard with inventory analytics | Medium |
| [#53](https://github.com/maximilianpw/librestock-inventory/issues/53) | Implement inventory reporting and export features | Medium |

### User Experience

| Issue | Description | Priority |
|-------|-------------|----------|
| [#51](https://github.com/maximilianpw/librestock-inventory/issues/51) | Add barcode/QR code scanning support | Medium |
| [#66](https://github.com/maximilianpw/librestock-inventory/issues/66) | Create getting started guide and seed data | Medium |
| [#44](https://github.com/maximilianpw/librestock-inventory/issues/44) | Implement user role-based access control (RBAC) | High |

### Infrastructure & Operations

| Issue | Description | Priority |
|-------|-------------|----------|
| [#59](https://github.com/maximilianpw/librestock-inventory/issues/59) | Configure production deployment (Docker + hosting) | High |
| [#60](https://github.com/maximilianpw/librestock-inventory/issues/60) | Add logging and monitoring infrastructure | High |
| [#61](https://github.com/maximilianpw/librestock-inventory/issues/61) | Set up database backup and recovery strategy | High |

### Quality & Testing

| Issue | Description | Priority |
|-------|-------------|----------|
| [#55](https://github.com/maximilianpw/librestock-inventory/issues/55) | Add unit and integration tests for API | High |
| [#56](https://github.com/maximilianpw/librestock-inventory/issues/56) | Add E2E tests for frontend with Playwright | Medium |
| [#62](https://github.com/maximilianpw/librestock-inventory/issues/62) | Create comprehensive documentation | Medium |

## Completed

These features have been implemented:

| Issue | Description | Status |
|-------|-------------|--------|
| [#40](https://github.com/maximilianpw/librestock-inventory/issues/40) | Create Categories management API | :white_check_mark: Done |
| [#45](https://github.com/maximilianpw/librestock-inventory/issues/45) | Build user authentication UI with Clerk | :white_check_mark: Done |
| [#46](https://github.com/maximilianpw/librestock-inventory/issues/46) | Create Categories and Locations management UI | :white_check_mark: Done |
| [#57](https://github.com/maximilianpw/librestock-inventory/issues/57) | Set up code quality tools and linting | :white_check_mark: Done |
| [#58](https://github.com/maximilianpw/librestock-inventory/issues/58) | Set up CI/CD pipeline with GitHub Actions | :white_check_mark: Done |
| [#63](https://github.com/maximilianpw/librestock-inventory/issues/63) | Add mobile-responsive PWA features | :white_check_mark: Done |

## Future Considerations

Features under consideration for future releases:

- **Multi-yacht support** - Manage inventory across multiple vessels
- **Supplier integration** - Direct ordering from suppliers
- **AI-powered predictions** - Automatic reorder suggestions
- **Mobile native apps** - iOS and Android applications
- **Offline-first sync** - Full offline capability with sync

## Release Planning

| Version | Focus | Target |
|---------|-------|--------|
| 0.1.0 | Core CRUD, Auth, Categories | Q1 2025 |
| 0.2.0 | Inventory Items, Locations, Suppliers | Q1 2025 |
| 0.3.0 | Search, Filters, Dashboard | Q2 2025 |
| 0.4.0 | Transactions, Alerts, Reports | Q2 2025 |
| 1.0.0 | Production ready, Full documentation | Q3 2025 |

---

*Last updated: December 2024*
