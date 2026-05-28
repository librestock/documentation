# Development Setup

This guide covers setting up the development environment for contributing to Stocket Inventory.

## Prerequisites

- Node.js >= 20.0.0
- pnpm >= 10.0.0
- Bun (runtime for the backend)
- PostgreSQL 16
- Git
- Nix with flakes enabled (optional — per-package dev shells)
- Infisical CLI + `just` (optional — used by `backend/justfile` for env setup)

## Clone & Install (Monorepo Root)

Stocket is a pnpm monorepo with a single lockfile at the workspace root. One `pnpm install` hydrates every package.

```bash
git clone https://github.com/stocket/stocket.git
cd stocket
pnpm install
```

!!! warning "Package manager"
    Only `pnpm` from the repo root. Running `npm install` or `bun install` at root will corrupt the workspace.

### Optional: Per-Package Nix Shells

There is **no root `flake.nix`**. If you want an isolated dev environment for a package, each of `backend/` and `frontend/` has its own flake:

```bash
cd backend && nix develop
cd frontend && nix develop
```

### Start Services

Docker Compose lives inside the monorepo at `meta/docker-compose.yml`:

```bash
cd meta && docker compose up -d
```

Then start the application servers from the repo root using workspace filters:

```bash
# Terminal 1 — Backend (runs with Bun)
pnpm --filter @stocket/api start

# Terminal 2 — Frontend
pnpm --filter @stocket/web dev
```

Services started:

| Service | URL | Description |
|---------|-----|-------------|
| PostgreSQL | localhost:5432 | Database |
| Effect.ts API | http://localhost:8080 | Backend (Bun) |
| TanStack Start | http://localhost:3000 | Frontend |
| MkDocs | http://localhost:8000 | Documentation |

## Common Commands

### Workspace Root

```bash
pnpm install                                   # Install every package's deps
pnpm --filter @stocket/api start            # Run backend
pnpm --filter @stocket/web dev              # Run frontend
pnpm --filter @stocket/types barrels        # Regenerate type barrels
pnpm --filter @stocket/types build          # Build shared types
```

!!! note "Legacy meta scripts"
    Commands like `pnpm sync` / `pnpm bootstrap` in `meta/` exist from the pre-monorepo era and are not needed for day-to-day work.

### Backend

```bash
cd backend
pnpm start             # Development server (Bun)
pnpm build             # Build (bun build)
pnpm test              # Run tests (Vitest)
pnpm test:watch        # Tests in watch mode
pnpm test:cov          # Tests with coverage
pnpm test:integration  # Integration tests
pnpm lint              # Lint (oxlint)
pnpm type-check        # TypeScript check
pnpm seed              # Seed sample data
```

### Frontend

```bash
cd frontend
pnpm dev               # Development server (Vite)
pnpm build             # Production build
pnpm lint              # oxlint
pnpm test:unit         # Vitest unit tests
pnpm test:e2e          # Playwright E2E
```

### Shared Types

Barrels must run **before** build — the generator only picks up `.type.ts` and `.enum.ts` files; other suffixes are silently ignored.

```bash
pnpm --filter @stocket/types barrels   # Generate barrel exports
pnpm --filter @stocket/types build     # Build shared types (ESM + CJS)
```

!!! warning "Bump the version when you change a shared package"
    If you edit `packages/types`, `packages/eslint-config`, or `packages/tsconfig`, bump that package's `package.json` version in the same PR. The `tag.yml` workflow publishes to npm on merge.

## Database Setup

### With Docker Compose

The database is automatically created and configured via Docker Compose in `meta/`.

### Manual Setup

```bash
createdb stocket_inventory
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
DATABASE_URL=postgresql://user@localhost:5432/stocket_inventory
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

### Environment Setup with Infisical

Use the `just` command runner and Infisical CLI for managing env variables:

```bash
cd backend && just env
cd ../frontend && just env
```

## IDE Setup

### VS Code

Recommended extensions:

- oxc (oxlint) — `oxc.oxc-vscode`
- Prettier
- Tailwind CSS IntelliSense
- TypeScript Importer
- Nix IDE (optional)

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
