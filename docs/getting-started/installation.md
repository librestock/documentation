# Installation

This guide covers setting up the LibreStock Inventory development environment.

## Using devenv (Recommended)

The project uses [devenv.sh](https://devenv.sh) for reproducible development environments.

### 1. Install Nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### 2. Install devenv

```bash
nix profile install nixpkgs#devenv
```

### 3. Clone and Enter Environment

```bash
git clone https://github.com/maximilianpw/librestock-inventory.git
cd librestock-inventory
devenv shell
```

This will:

- Install Node.js 24 and pnpm 10
- Install Python 3.12 with MkDocs
- Set up PostgreSQL 16
- Configure all environment variables

### 4. Install Dependencies

```bash
pnpm install
```

### 5. Start Development Services

```bash
devenv up
```

This starts:

| Service | URL | Description |
|---------|-----|-------------|
| PostgreSQL | localhost:5432 | Database |
| NestJS API | http://localhost:8080 | Backend + Swagger |
| TanStack Start Web | http://localhost:3000 | Frontend |
| MkDocs | http://localhost:8000 | Documentation |

## Manual Setup (Alternative)

If you prefer not to use devenv:

### Prerequisites

- Node.js >= 20.0.0
- pnpm >= 10.0.0
- PostgreSQL 16
- Python 3.12 (for docs)

### Database Setup

```bash
createdb librestock_inventory
```

### Environment Variables

Copy the environment template:

```bash
cp modules/api/.env.template modules/api/.env
```

Edit `.env` with your configuration:

```bash
DATABASE_URL=postgresql://user@localhost:5432/librestock_inventory
CLERK_SECRET_KEY=sk_test_...
PORT=8080
```

### Start Services

```bash
# Terminal 1: API
cd modules/api && pnpm start:dev

# Terminal 2: Web
cd modules/web && pnpm dev
```

## Verify Installation

1. Open http://localhost:8080/api/docs - You should see Swagger UI
2. Open http://localhost:3000 - You should see the login page

## Next Steps

- [Quick Start](quick-start.md) - Create your first products
- [Configuration](configuration.md) - Learn about configuration options
