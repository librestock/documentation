# CLI Commands

Reference of all available command line commands for LibreStock Inventory.

## Package Manager

All commands use pnpm. Run from the repository root or use the `--filter` flag.

## Backend Commands

Use `pnpm --filter @librestock/api <command>` or `cd backend && pnpm <command>`.

### Development

```bash
# Start development server with hot reload
pnpm --filter @librestock/api start:dev

# Start in debug mode
pnpm --filter @librestock/api start:debug

# Build the application
pnpm --filter @librestock/api build

# Start production server
pnpm --filter @librestock/api start:prod
```

### Testing

```bash
# Run unit tests (Jest 30)
pnpm --filter @librestock/api test

# Run tests in watch mode
pnpm --filter @librestock/api test:watch

# Run tests with coverage
pnpm --filter @librestock/api test:cov

# Run end-to-end tests
pnpm --filter @librestock/api test:e2e

# Debug tests
pnpm --filter @librestock/api test:debug
```

### Code Quality

```bash
# Lint code
pnpm --filter @librestock/api lint

# Format code with Prettier
pnpm --filter @librestock/api format

# TypeScript type check
pnpm --filter @librestock/api type-check
```

### Database

```bash
# Seed the database
pnpm --filter @librestock/api seed

# Import from Sortly
pnpm --filter @librestock/api import:sortly

# Generate a TypeORM migration
pnpm --filter @librestock/api migration:generate

# Run pending migrations
pnpm --filter @librestock/api migration:run

# Revert the last migration
pnpm --filter @librestock/api migration:revert
```

## Frontend Commands

Use `pnpm --filter @librestock/web <command>` or `cd frontend && pnpm <command>`.

### Development

```bash
# Start development server (port 3000)
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

# TypeScript type check
pnpm --filter @librestock/web type-check

# Run all validations (type-check + lint + format check)
pnpm --filter @librestock/web validate

# Prettier write + ESLint fix
pnpm --filter @librestock/web check
```

### Testing

```bash
# Run Playwright E2E tests
pnpm --filter @librestock/web test:e2e

# Playwright UI mode
pnpm --filter @librestock/web test:e2e:ui

# Headed browser tests
pnpm --filter @librestock/web test:e2e:headed
```

## Shared Types

```bash
# Generate barrel files
pnpm --filter @librestock/types barrels

# Build shared types
pnpm --filter @librestock/types build
```

## Meta Workspace Commands

Run from the `meta/` directory:

```bash
# Sync repos + install dependencies
./scripts/bootstrap

# Run backend + frontend dev servers
./scripts/dev

# Also start Docker services (PostgreSQL, etc.)
./scripts/dev --with-docker

# Sync repos from repos.yaml
./scripts/clone-or-update

# Alternative: use workspace.mjs directly
node scripts/workspace.mjs sync
node scripts/workspace.mjs bootstrap
node scripts/workspace.mjs dev [--include-desktop] [--include-docs] [--with-docker]
```

## Docker Compose

Start development services (PostgreSQL):

```bash
docker compose -f meta/docker-compose.yml up -d
```

## Just Commands

Both backend and frontend have a `justfile`. Requires the [`just`](https://github.com/casey/just) command runner.

```bash
# Install dependencies
just bootstrap

# Decrypt env vars with 1Password CLI
just decrypt

# Run dev server
just dev

# Build for production
just build

# Run tests
just test
```

!!!tip "1Password CLI"
    The `just decrypt` command runs `op inject -i env.template -o .env` to generate `.env` files from templates using 1Password CLI.

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
pnpm --filter @librestock/types barrels && pnpm --filter @librestock/types build
```
