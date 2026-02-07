# Environment Variables

Complete reference of all environment variables used in LibreStock Inventory.

## API Module

Location: `modules/api/.env`

### Database

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `DATABASE_URL` | Yes* | Full PostgreSQL connection string | `postgresql://user:pass@localhost:5432/librestock` |
| `PGHOST` | Yes* | PostgreSQL host | `localhost` |
| `PGPORT` | Yes* | PostgreSQL port | `5432` |
| `PGUSER` | Yes* | PostgreSQL user | `postgres` |
| `PGPASSWORD` | Yes* | PostgreSQL password | `secret` |
| `PGDATABASE` | Yes* | PostgreSQL database name | `librestock_inventory` |

*Either `DATABASE_URL` or individual `PG*` variables are required.

### Authentication

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `CLERK_SECRET_KEY` | Yes | Clerk backend API key | `sk_test_xxx...` |

### Server

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `PORT` | No | `8080` | API server port |
| `NODE_ENV` | No | `development` | Environment mode |

### Example `.env`

```bash
# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/librestock_inventory

# Authentication
CLERK_SECRET_KEY=sk_test_xxxxxxxxxxxx

# Server
PORT=8080
NODE_ENV=development
```

## Web Module

Location: `modules/web/.env.local`

### API

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `VITE_API_BASE_URL` | Yes | Backend API URL | `http://localhost:8080` |

### Authentication

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `VITE_CLERK_PUBLISHABLE_KEY` | Yes | Clerk frontend API key | `pk_test_xxx...` |

### Example `.env.local`

```bash
# API
VITE_API_BASE_URL=http://localhost:8080

# Authentication
VITE_CLERK_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxx
```

## CI/CD Secrets

GitHub Actions secrets required for CI/CD:

| Secret | Description |
|--------|-------------|
| `CLERK_SECRET_KEY` | Clerk API key for CI tests |
| `AWS_DOCS_ROLE_ARN` | IAM role for docs deployment |
| `DOCS_S3_BUCKET` | S3 bucket for documentation |
| `DOCS_CLOUDFRONT_DISTRIBUTION_ID` | CloudFront distribution ID |

## Production Considerations

### Security

- Never commit `.env` files
- Use secrets management in production
- Rotate keys regularly

### Clerk

- Use production keys in production environment
- Configure allowed origins in Clerk dashboard

### Database

- Use connection pooling in production
- Enable SSL for database connections
