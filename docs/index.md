# LibreStock Inventory System

Welcome to the LibreStock Inventory documentation. This system helps manage yacht provisioning inventory with features for product management, order tracking, and audit logging.

Built with NestJS (backend), TanStack Start with React 19 (frontend), PostgreSQL, Better Auth, and TypeORM.

## Quick Links

<div class="grid cards" markdown>

- :material-rocket-launch: **Getting Started**

    Get up and running with LibreStock Inventory in minutes.

    [:octicons-arrow-right-24: Installation](getting-started/installation.md)

- :material-book-open-variant: **User Guide**

    Learn how to use all features of the application.

    [:octicons-arrow-right-24: User Guide](user-guide/index.md)

- :material-code-braces: **Development**

    Set up your development environment and contribute.

    [:octicons-arrow-right-24: Development](development/index.md)

- :material-map: **Roadmap**

    See what's planned for future releases.

    [:octicons-arrow-right-24: Roadmap](roadmap.md)

</div>

## Features

- **Product Management** - Create and organize products with SKUs, pricing, and categories
- **Category Hierarchy** - Multi-level categorization with unlimited nesting
- **Location Tracking** - Manage warehouses, suppliers, clients, and in-transit locations
- **Area Management** - Define zones, shelves, and bins within locations
- **Inventory Control** - Track stock quantities across locations with batch and expiry tracking
- **Stock Movements** - Track and record stock movements between locations
- **Order Processing** - Track yacht provisioning orders through complete lifecycle (DRAFT, CONFIRMED, SOURCING, PICKING, PACKED, SHIPPED, DELIVERED, CANCELLED, ON_HOLD)
- **Clients Module** - Manage client information and relationships
- **Suppliers Module** - Manage supplier information and relationships
- **Audit Trail** - Complete change history with user tracking
- **Authentication** - Better Auth authentication system
- **Roles & Permissions** - Role-based access control with PermissionGuard and @RequirePermission
- **Users Management** - Admin user management
- **Photos Management** - Product and inventory photo management
- **Branding/Customization** - Customizable branding options
- **Multi-language** - English, French, and German support
- **HATEOAS REST API** - Hypermedia-driven API design
- **E2E Testing** - End-to-end testing with Playwright
- **Docker Support** - Docker Compose for containerized deployment
- **CI/CD** - Per-repo GitHub Actions pipelines
- **Documentation** - MkDocs site with GitHub Pages
- **QR Scanning** - Barcode scanning for quick product lookup
