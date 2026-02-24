# Configuration

This guide covers all configuration options for LibreStock Inventory.

## Environment Variables

### Backend API

Located in `backend/.env`:

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | Yes | PostgreSQL connection string |
| `NODE_ENV` | No | Environment mode (default: `development`) |
| `PORT` | No | API port (default: `8080`) |
| `CORS_ORIGIN` | No | Allowed CORS origin (default: `http://localhost:3000`) |
| `BETTER_AUTH_SECRET` | Yes | Random 32+ byte string for Better Auth session signing |
| `BETTER_AUTH_URL` | Yes | Better Auth server URL (e.g. `http://localhost:8080`) |
| `FRONTEND_URL` | No | Frontend URL for redirects (default: `http://localhost:3000`) |

Individual database variables are also supported: `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`.

**Example:**

```bash
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/librestock_inventory
NODE_ENV=development
PORT=8080
CORS_ORIGIN=http://localhost:3000
BETTER_AUTH_SECRET=<random 32+ byte string>
BETTER_AUTH_URL=http://localhost:8080
FRONTEND_URL=http://localhost:3000
```

### Frontend Web

Located in `frontend/.env`:

| Variable | Required | Description |
|----------|----------|-------------|
| `VITE_API_BASE_URL` | Yes | Backend API URL |
| `VITE_SENTRY_DSN` | No | Sentry DSN for error tracking |
| `SENTRY_AUTH_TOKEN` | No | Sentry auth token for source maps |

**Example:**

```bash
VITE_API_BASE_URL=http://localhost:8080/api/v1
VITE_SENTRY_DSN=<sentry dsn>
SENTRY_AUTH_TOKEN=<sentry auth token>
```

## Better Auth Authentication

Better Auth is configured in the backend only. The `BETTER_AUTH_SECRET` must be a random string of at least 32 bytes. You can generate one with:

```bash
openssl rand -base64 32
```

`BETTER_AUTH_URL` should point to the backend server URL where Better Auth endpoints are served.

!!!note
    `BETTER_AUTH_SECRET` lives only in the backend `.env` -- it is never set in the frontend.

## Database Configuration

### Using Docker Compose (Recommended)

PostgreSQL is provided by Docker Compose:

```bash
docker compose -f meta/docker-compose.yml up -d
```

Default configuration:

- Database name: `librestock_inventory`
- Host: `localhost`
- Port: `5432`
- User: `postgres`
- Password: `postgres`

### Manual Configuration

Create the database:

```bash
createdb librestock_inventory
```

Set the connection string:

```bash
DATABASE_URL=postgresql://username:password@localhost:5432/librestock_inventory
```

## API Documentation

Swagger UI is available at:

- http://localhost:8080/api/docs
- OpenAPI JSON: http://localhost:8080/api/docs-json

## Next Steps

- [Architecture](../development/architecture.md) - Understand the system design
- [Development Setup](../development/setup.md) - Set up for development
