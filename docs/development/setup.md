# Development Setup

This guide covers setting up the development environment for contributing to LibreStock Inventory.

## Prerequisites

- Node.js >= 20.0.0
- pnpm >= 10.0.0
- PostgreSQL 16
- Nix with flakes enabled (recommended)
- Git
- 1Password CLI (for env setup)
- just command runner (for env setup)

## Using Nix Flakes (Recommended)

Each repo has its own Nix flake for reproducible development shells.

### Enter Development Shell

```bash
git clone https://github.com/librestock/meta.git
cd meta && ./scripts/bootstrap && cd ..

# Backend dev shell
cd backend && nix develop

# Frontend dev shell
cd frontend && nix develop
```

This provides:

- Node.js 20+ and pnpm 10
- Python 3.12 with MkDocs
- All environment variables configured

### Install Dependencies

```bash
pnpm install
```

### Start Services

Use Docker Compose in `meta/` for services:

```bash
cd meta && docker compose up -d
```

Then start the application servers:

```bash
# Terminal 1 - Backend
cd backend
pnpm start:dev

# Terminal 2 - Frontend
cd frontend
pnpm dev
```

Services started:

| Service | URL | Description |
|---------|-----|-------------|
| PostgreSQL | localhost:5432 | Database |
| NestJS API | http://localhost:8080 | Backend |
| TanStack Start | http://localhost:3000 | Frontend |
| MkDocs | http://localhost:8000 | Documentation |

## Common Commands

### Meta Level

```bash
cd meta
pnpm sync              # Sync all repos
pnpm bootstrap         # Bootstrap all repos
pnpm dev               # Start all services for development
```

### Backend

```bash
cd backend
pnpm start:dev         # Development server
pnpm build             # Build
pnpm test              # Run tests
pnpm test:e2e          # E2E tests
```

### Frontend

```bash
cd frontend
pnpm dev               # Development server
pnpm build             # Production build
pnpm lint              # Lint
```

### Shared Types

```bash
pnpm --filter @librestock/types barrels   # Generate barrel exports
pnpm --filter @librestock/types build     # Build shared types
```

## Database Setup

### With Docker Compose

The database is automatically created and configured via Docker Compose in `meta/`.

### Manual Setup

```bash
createdb librestock_inventory
```

### Seed Data

Populate with sample data:

```bash
cd backend
pnpm seed
```

## Environment Variables

### Backend (.env)

```bash
DATABASE_URL=postgresql://user@localhost:5432/librestock_inventory
BETTER_AUTH_SECRET=your-secret-here
PORT=8080
NODE_ENV=development
```

### Frontend (.env.local)

```bash
VITE_API_BASE_URL=http://localhost:8080/api/v1
```

!!! note "Better Auth secret"
    `BETTER_AUTH_SECRET` lives only in the backend `.env` -- never in the frontend.

### Environment Setup with 1Password

Use the `just` command runner and 1Password CLI for managing env variables:

```bash
just env-setup
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
rm -rf backend/node_modules
rm -rf frontend/node_modules
pnpm install
```
