# CLI Commands

Reference of all available command line commands for LibreStock Inventory.

## Package Manager

All commands use pnpm. Run from the repository root.

## Root Commands

### Installation

```bash
# Install all dependencies
pnpm install

# Clean install (remove node_modules first)
rm -rf node_modules && pnpm install
```

### Development

```bash
# Start all services with devenv
devenv up

# Build all packages
pnpm build

# Lint all packages
pnpm lint

# Run all tests
pnpm test
```

### Documentation

```bash
# Serve docs locally
pnpm docs:dev

# Build docs (with strict mode)
pnpm docs:build
```

## API Module Commands

Use `pnpm --filter @librestock/api <command>` or run from `modules/api/`.

### Development

```bash
# Start development server with hot reload
pnpm --filter @librestock/api start:dev

# Start production server
pnpm --filter @librestock/api start:prod

# Build the application
pnpm --filter @librestock/api build
```

### Testing

```bash
# Run unit tests
pnpm --filter @librestock/api test

# Run tests in watch mode
pnpm --filter @librestock/api test:watch

# Run tests with coverage
pnpm --filter @librestock/api test:cov

# Run end-to-end tests
pnpm --filter @librestock/api test:e2e
```

### Code Quality

```bash
# Lint code
pnpm --filter @librestock/api lint

# Lint and fix
pnpm --filter @librestock/api lint --fix
```

### Shared Types

```bash
# Build shared types
pnpm --filter @librestock/types build
```

## Web Module Commands

Use `pnpm --filter @librestock/web <command>` or run from `modules/web/`.

### Development

```bash
# Start development server
pnpm --filter @librestock/web dev

# Build for production
pnpm --filter @librestock/web build

# Start production server
pnpm --filter @librestock/web start
```

### Code Quality

```bash
# Lint code
pnpm --filter @librestock/web lint

# Lint and fix
pnpm --filter @librestock/web lint:fix
```


## Devenv Commands

When using devenv:

```bash
# Start all services (PostgreSQL, API, Web)
devenv up

# Enter devenv shell
devenv shell

# Run specific process
devenv processes up api
devenv processes up web
devenv processes up docs
```

## Database Commands

With PostgreSQL running:

```bash
# Connect to database
psql -h localhost -p 5432 -U postgres -d librestock_inventory

# Check database status
pg_isready -h localhost -p 5432
```

## Useful Combinations

```bash
# Full rebuild
pnpm install && pnpm build

# Pre-commit check
pnpm lint && pnpm test && pnpm build

# Update shared types after backend changes
pnpm --filter @librestock/types build
```
