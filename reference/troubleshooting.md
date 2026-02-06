# Troubleshooting

Solutions to common issues when working with LibreStock Inventory.

## Development Environment

### Devenv won't start

**Symptom:** `devenv up` fails or hangs

**Solutions:**

1. Check Nix installation:
   ```bash
   nix --version
   ```

2. Update devenv:
   ```bash
   nix-env -iA devenv -f https://github.com/NixOS/nixpkgs/tarball/nixos-unstable
   ```

3. Clear devenv cache:
   ```bash
   rm -rf .devenv
   devenv up
   ```

### Port already in use

**Symptom:** "Address already in use" error

**Solutions:**

```bash
# Find process using the port
lsof -i :8080  # or :3000, :5432

# Kill the process
kill -9 <PID>
```

### Dependencies won't install

**Symptom:** `pnpm install` fails

**Solutions:**

1. Clear pnpm cache:
   ```bash
   pnpm store prune
   rm -rf node_modules
   pnpm install
   ```

2. Check Node.js version:
   ```bash
   node --version  # Should be 22+
   ```

## Database Issues

### Cannot connect to PostgreSQL

**Symptom:** Connection refused errors

**Solutions:**

1. Check if PostgreSQL is running:
   ```bash
   pg_isready -h localhost -p 5432
   ```

2. With devenv, ensure it's started:
   ```bash
   devenv up
   ```

3. Check environment variables in `.env`

### Migration errors

**Symptom:** TypeORM errors about schema

**Solutions:**

1. Sync schema (development only):
   ```bash
   # TypeORM synchronize is enabled in dev
   # Restart the API server
   ```

2. Check database exists:
   ```bash
   psql -h localhost -U postgres -c '\l'
   ```

## API Issues

### Clerk authentication errors

**Symptom:** 401 Unauthorized errors

**Solutions:**

1. Verify `CLERK_SECRET_KEY` in `modules/api/.env`
2. Check token is being sent:
   ```bash
   # Request should include:
   # Authorization: Bearer <token>
   ```
3. Verify Clerk dashboard configuration

### Shared types build fails

**Symptom:** `@librestock/types` build fails

**Solutions:**

1. Build the API first:
   ```bash
   pnpm --filter @librestock/api build
   ```

2. Check for TypeScript errors:
   ```bash
   pnpm --filter @librestock/api build
   ```

## Frontend Issues

### API client type errors

**Symptom:** TypeScript errors in handwritten hooks or shared types

**Solutions:**

1. Rebuild shared types after API changes:
   ```bash
   pnpm --filter @librestock/types build
   ```

### Hydration errors

**Symptom:** React hydration mismatch warnings

**Solutions:**

1. Ensure client/server rendering matches
2. Avoid browser-only code at module scope during SSR
3. Defer browser APIs to effects or guards

### Translation not working

**Symptom:** Translation keys shown instead of text

**Solutions:**

1. Check locale files exist in `modules/web/src/locales/`
2. Verify i18n configuration
3. Check language prefix in URL

## Build Issues

### TypeScript errors

**Symptom:** Build fails with type errors

**Solutions:**

```bash
# Check specific module
pnpm --filter @librestock/api build
pnpm --filter @librestock/web build

```

### ESLint errors

**Symptom:** Lint command fails

**Solutions:**

```bash
# Auto-fix what's possible
pnpm --filter @librestock/api lint --fix
pnpm --filter @librestock/web lint:fix
```

## CI/CD Issues

### GitHub Actions failing

**Symptom:** CI checks fail

**Solutions:**

1. Run checks locally first:
   ```bash
   pnpm lint && pnpm test && pnpm build
   ```

2. Check secrets are configured in GitHub

3. Clear GitHub Actions cache if needed

## Getting More Help

If you're still stuck:

1. Check [existing issues](https://github.com/your-org/librestock/issues)
2. Search error messages online
3. Open a new issue with:
    - Error message
    - Steps to reproduce
    - Environment details
