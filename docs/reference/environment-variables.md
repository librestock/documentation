# Environment Variables

Complete reference of all environment variables used in LibreStock Inventory.

## Backend API

Location: `backend/.env`

### Database

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `DATABASE_URL` | Yes* | Full PostgreSQL connection string | `postgresql://postgres:postgres@localhost:5432/librestock_inventory` |
| `PGHOST` | Yes* | PostgreSQL host | `localhost` |
| `PGPORT` | Yes* | PostgreSQL port | `5432` |
| `PGUSER` | Yes* | PostgreSQL user | `postgres` |
| `PGPASSWORD` | Yes* | PostgreSQL password | `postgres` |
| `PGDATABASE` | Yes* | PostgreSQL database name | `librestock_inventory` |

*Either `DATABASE_URL` or individual `PG*` variables are required.

### Authentication

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `BETTER_AUTH_SECRET` | Yes | Random 32+ byte string for session signing | `<output of openssl rand -base64 32>` |
| `BETTER_AUTH_URL` | Yes | Backend server URL for Better Auth | `http://localhost:8080` |

### Server

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `PORT` | No | `8080` | API server port |
| `NODE_ENV` | No | `development` | Environment mode |
| `CORS_ORIGIN` | No | `http://localhost:3000` | Allowed CORS origin |
| `FRONTEND_URL` | No | `http://localhost:3000` | Frontend URL for redirects |

### Example `.env`

```bash
# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/librestock_inventory

# Authentication
BETTER_AUTH_SECRET=<random 32+ byte string>
BETTER_AUTH_URL=http://localhost:8080

# Server
PORT=8080
NODE_ENV=development
CORS_ORIGIN=http://localhost:3000
FRONTEND_URL=http://localhost:3000
```

## Frontend Web

Location: `frontend/.env`

### API

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `VITE_API_BASE_URL` | Yes | Backend API URL | `http://localhost:8080/api/v1` |

### Monitoring

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `VITE_SENTRY_DSN` | No | Sentry DSN for error tracking | `https://xxx@sentry.io/xxx` |
| `SENTRY_AUTH_TOKEN` | No | Sentry auth token for source maps | `sntrys_xxx...` |

### Example `.env`

```bash
# API
VITE_API_BASE_URL=http://localhost:8080/api/v1

# Monitoring (optional)
VITE_SENTRY_DSN=<sentry dsn>
SENTRY_AUTH_TOKEN=<sentry auth token>
```

## Setting Up Environment Files

**Backend:**

```bash
cp backend/.env.template backend/.env
```

**Frontend:**

```bash
echo "VITE_API_BASE_URL=http://localhost:8080/api/v1" > frontend/.env
```

!!!tip "1Password CLI"
    Both repos have a `justfile` with a `decrypt` task that uses 1Password CLI:
    ```bash
    cd backend && just decrypt
    cd frontend && just decrypt
    ```
    This runs `op inject -i env.template -o .env` to populate secrets from 1Password.

## CI/CD Secrets

GitHub Actions secrets required for CI/CD:

| Secret | Description |
|--------|-------------|
| `BETTER_AUTH_SECRET` | Better Auth secret for CI tests |

## Documentation Deployment

Documentation is deployed via GitHub Pages:

- **Site URL:** https://librestock.github.io/documentation/
- **Repo:** https://github.com/librestock/documentation

## Production Considerations

### Security

- Never commit `.env` files
- Use secrets management in production
- Rotate keys regularly

### Better Auth

- Use a strong, unique `BETTER_AUTH_SECRET` in production (32+ random bytes)
- Set `BETTER_AUTH_URL` to your production backend URL

### Database

- Use connection pooling in production
- Enable SSL for database connections
