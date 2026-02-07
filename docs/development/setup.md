# Development Setup

This guide covers setting up the development environment for contributing to LibreStock Inventory.

## Prerequisites

- Node.js >= 20.0.0
- pnpm >= 10.0.0
- Nix with flakes (for devenv)
- Git

## Using devenv (Recommended)

The project uses [devenv.sh](https://devenv.sh) for reproducible development environments.

### Enter Development Shell

```bash
git clone https://github.com/maximilianpw/librestock-inventory.git
cd librestock-inventory
devenv shell
```

This provides:

- Node.js 24 and pnpm 10
- Python 3.12 with MkDocs
- PostgreSQL 16
- All environment variables configured

### Install Dependencies

```bash
pnpm install
```

### Start Services

```bash
devenv up
```

Services started:

| Service | URL | Description |
|---------|-----|-------------|
| PostgreSQL | localhost:5432 | Database |
| NestJS API | http://localhost:8080 | Backend |
| TanStack Start | http://localhost:3000 | Frontend |
| MkDocs | http://localhost:8000 | Documentation |

## Common Commands

### Root Level

```bash
pnpm install          # Install all dependencies
pnpm build            # Build all packages
pnpm lint             # Lint all packages
pnpm test             # Test all packages
pnpm docs:dev         # Start documentation server
pnpm docs:build       # Build documentation
```

### API Module

```bash
pnpm --filter @librestock/api start:dev      # Development server
pnpm --filter @librestock/api build          # Build
pnpm --filter @librestock/api test           # Run tests
pnpm --filter @librestock/api test:e2e       # E2E tests
pnpm --filter @librestock/types build        # Build shared types
```

### Web Module

```bash
pnpm --filter @librestock/web dev           # Development server
pnpm --filter @librestock/web build         # Production build
pnpm --filter @librestock/web lint          # Lint
```

## Database Setup

### With devenv

The database is automatically created and configured.

### Manual Setup

```bash
createdb librestock_inventory
```

### Seed Data

Populate with sample data:

```bash
cd modules/api
pnpm seed
```

## Environment Variables

### API (.env)

```bash
DATABASE_URL=postgresql://user@localhost:5432/librestock_inventory
CLERK_SECRET_KEY=sk_test_...
PORT=8080
NODE_ENV=development
```

### Web (.env.local)

```bash
VITE_API_BASE_URL=http://localhost:8080/api/v1
VITE_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
```

## IDE Setup

### VS Code

Recommended extensions:

- ESLint
- Prettier
- Tailwind CSS IntelliSense
- TypeScript Importer
- Nix IDE

### Settings

The project includes workspace settings in `.vscode/settings.json`.

## Troubleshooting

### Port Already in Use

```bash
# Find process using port
lsof -i :8080
lsof -i :3000

# Kill process
kill -9 <PID>
```

### Database Connection Issues

Check PostgreSQL is running:

```bash
pg_isready -h localhost -p 5432
```

### Node Modules Issues

Clean install:

```bash
rm -rf node_modules
rm -rf modules/*/node_modules
pnpm install
```
