# Development

This section covers everything you need to contribute to the LibreStock Inventory codebase.

## Overview

LibreStock Inventory is a pnpm monorepo containing:

- **@librestock/api** - NestJS backend
- **@librestock/web** - TanStack Start frontend

## Quick Links

- [Architecture](architecture.md) - System design and tech stack
- [Setup](setup.md) - Development environment configuration
- [Code Style](code-style.md) - ESLint, Prettier, and conventions
- [Testing](testing.md) - Jest test patterns
- [API Development](api-development.md) - NestJS patterns
- [Frontend Development](frontend-development.md) - TanStack Start patterns
- [CI/CD](ci-cd.md) - GitHub Actions workflows

## Development Workflow

1. **Start the environment**

    ```bash
    devenv up
    ```

2. **Make changes** to the codebase

3. **Update shared types** (if DTO shapes changed)

    ```bash
    pnpm --filter @librestock/types build
    ```

4. **Run tests and lint**

    ```bash
    pnpm test
    pnpm lint
    ```

5. **Submit a pull request**
