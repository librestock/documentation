# Reference

Technical reference documentation for LibreStock Inventory.

## Contents

- [Environment Variables](environment-variables.md) - All configuration options
- [CLI Commands](cli-commands.md) - Available command line commands
- [Troubleshooting](troubleshooting.md) - Common issues and solutions

## Quick Links

### API Documentation

The API is documented via Swagger UI:

- **Local:** http://localhost:8080/api/docs
- **OpenAPI JSON:** http://localhost:8080/api/docs-json

### Shared Types

Shared DTO interfaces/enums live in `packages/types`:

```bash
pnpm --filter @librestock/types build
```

Types are authored in `packages/types/src/`.
