# Installation

This guide covers setting up the LibreStock Inventory development environment.

## Using Nix Flakes + Docker (Recommended)

The project uses per-repo [Nix flakes](https://nixos.wiki/wiki/Flakes) for reproducible development environments and Docker Compose for services like PostgreSQL.

### 1. Install Nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Ensure flakes are enabled in your Nix configuration.

### 2. Clone the Workspace

```bash
git clone https://github.com/librestock/meta.git
cd meta && ./scripts/bootstrap && cd ..
```

### 3. Bootstrap the Workspace

```bash
./meta/scripts/bootstrap
```

This will sync all repos and install dependencies.

### 4. Enter a Nix Shell (per-repo)

Each repo (backend, frontend, etc.) has its own `flake.nix`. Enter the shell for the repo you need:

```bash
cd backend && nix develop
# or
cd frontend && nix develop
```

This will provide:

- Node.js 20+ and pnpm 10
- All repo-specific tooling

### 5. Start Development Services

Start PostgreSQL and other services via Docker Compose:

```bash
docker compose -f meta/docker-compose.yml up -d
```

Or use the meta dev script to start everything (backend + frontend dev servers):

```bash
./meta/scripts/dev
```

To also start Docker services automatically:

```bash
./meta/scripts/dev --with-docker
```

This starts:

| Service | URL | Description |
|---------|-----|-------------|
| PostgreSQL | localhost:5432 | Database |
| NestJS API | http://localhost:8080 | Backend + Swagger |
| TanStack Start Web | http://localhost:3000 | Frontend |

### 6. Configure Environment Variables

**Backend:**

```bash
cp backend/.env.template backend/.env
```

Edit `backend/.env` with your configuration:

```bash
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/librestock_inventory
NODE_ENV=development
PORT=8080
CORS_ORIGIN=http://localhost:3000
BETTER_AUTH_SECRET=<random 32+ byte string>
BETTER_AUTH_URL=http://localhost:8080
FRONTEND_URL=http://localhost:3000
```

**Frontend:**

```bash
echo "VITE_API_BASE_URL=http://localhost:8080/api/v1" > frontend/.env
```

!!!tip "1Password CLI"
    Both backend and frontend have a `justfile` with a `decrypt` task. If you use 1Password CLI, you can generate `.env` files automatically:
    ```bash
    cd backend && just decrypt
    cd frontend && just decrypt
    ```
    This runs `op inject -i env.template -o .env` to populate secrets from 1Password.

## Manual Setup (Alternative)

If you prefer not to use Nix:

### Prerequisites

- Node.js >= 20
- pnpm >= 10
- PostgreSQL 16
- Python 3.12 (for docs)

### Database Setup

```bash
createdb librestock_inventory
```

### Environment Variables

Copy the environment template:

```bash
cp backend/.env.template backend/.env
```

Edit `backend/.env` with your configuration (see table above).

### Start Services

```bash
# Terminal 1: API
cd backend && pnpm start:dev

# Terminal 2: Web
cd frontend && pnpm dev
```

## Verify Installation

1. Open http://localhost:8080/api/docs - You should see Swagger UI
2. Open http://localhost:3000 - You should see the login page

## Next Steps

- [Quick Start](quick-start.md) - Create your first products
- [Configuration](configuration.md) - Learn about configuration options
