# CLI Commands

Reference of all available command line commands for Stocket Inventory.

## Package Manager

All commands use pnpm. Run from the repository root or use the `--filter` flag.

## Backend Commands

Use `pnpm --filter @stocket/api <command>` or `cd backend && pnpm <command>`.

### Development

```bash
# Start development server (Bun)
pnpm --filter @stocket/api start

# Build the application (bun build)
pnpm --filter @stocket/api build

# Start production server
pnpm --filter @stocket/api start:prod
```

### Testing

```bash
# Run unit tests (Vitest)
pnpm --filter @stocket/api test

# Run tests in watch mode
pnpm --filter @stocket/api test:watch

# Run tests with coverage
pnpm --filter @stocket/api test:cov

# Run integration tests
pnpm --filter @stocket/api test:integration
```

### Code Quality

```bash
# Lint code (oxlint)
pnpm --filter @stocket/api lint

# Lint with auto-fix
pnpm --filter @stocket/api lint:fix

# Format code with Prettier
pnpm --filter @stocket/api format

# TypeScript type check
pnpm --filter @stocket/api type-check
```

### Database

```bash
# Seed the database with sample data
pnpm --filter @stocket/api seed

# Import from Sortly
pnpm --filter @stocket/api import:sortly
```

!!! note "Migrations"
    Database schema is managed via Drizzle ORM. Schema changes are defined in `backend/src/effect/platform/db/schema.ts` and applied automatically on startup in development.

## Frontend Commands

Use `pnpm --filter @stocket/web <command>` or `cd frontend && pnpm <command>`.

### Development

```bash
# Start development server (port 3000)
pnpm --filter @stocket/web dev

# Build for production
pnpm --filter @stocket/web build

# Start production server
pnpm --filter @stocket/web start
```

### Code Quality

```bash
# Lint code
pnpm --filter @stocket/web lint

# Lint and fix
pnpm --filter @stocket/web lint:fix

# TypeScript type check
pnpm --filter @stocket/web type-check

# Run all validations (type-check + lint + format check)
pnpm --filter @stocket/web validate

# Prettier write + ESLint fix
pnpm --filter @stocket/web check
```

### Testing

```bash
# Run Playwright E2E tests
pnpm --filter @stocket/web test:e2e

# Playwright UI mode
pnpm --filter @stocket/web test:e2e:ui

# Headed browser tests
pnpm --filter @stocket/web test:e2e:headed
```

## Shared Types

```bash
# Generate barrel files
pnpm --filter @stocket/types barrels

# Build shared types
pnpm --filter @stocket/types build
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

# Export env vars with Infisical CLI
just env

# Run dev server
just dev

# Build for production
just build

# Run tests
just test
```

!!!tip "Infisical CLI"
    The `just env` command runs `infisical export --env=dev --format=dotenv > .env` to generate `.env` files from templates using Infisical CLI.

## Database Commands

With PostgreSQL running:

```bash
# Connect to database
psql -h localhost -p 5432 -U postgres -d stocket_inventory

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
pnpm --filter @stocket/types barrels && pnpm --filter @stocket/types build
```
