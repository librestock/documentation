# CI/CD

This guide covers the GitHub Actions workflows and deployment processes for Stocket Inventory.

## Workflows

CI workflows live **per-package** for backend/frontend/documentation, and **at the monorepo root** for cross-package concerns (mobile-app, shared packages).

### Backend CI Pipeline

**File:** `backend/.github/workflows/ci.yml`

Runs on every pull request and push to main:

- Lint (oxlint)
- Type check
- Unit tests (Vitest)
- Integration tests (against a real Postgres service)
- Build (bun build)

### Frontend CI Pipeline

**File:** `frontend/.github/workflows/ci.yml`

Runs on every pull request and push to main:

- Lint (oxlint)
- Type check
- Build

### Mobile CI Pipeline (Root-Level)

**File:** `.github/workflows/mobile-ci.yml`

Lives at the workspace root because it rebuilds shared types before testing `mobile-app/`. Triggers on changes to `mobile-app/**` or `packages/**`.

### Docker Publish

Each application package has its own Docker publish workflow:

- **Backend:** `backend/.github/workflows/docker-publish.yml`
- **Frontend:** `frontend/.github/workflows/docker-publish.yml`

### Documentation Deployment

**File:** `documentation/.github/workflows/deploy.yml`

Deploys the MkDocs site to GitHub Pages on push to main.

### Package Release (npm)

Shared packages (`@stocket/types`, `@stocket/eslint-config`, `@stocket/tsconfig`) publish to npm via trusted publishing when their `package.json` version is bumped on `main`.

- **Trigger:** merge to `main` with a version bump in `packages/<name>/package.json`
- **Workflow:** `tag.yml` (at the monorepo root)
- **Tag format:** `types@x.y.z`, `eslint-config@x.y.z`, `tsconfig@x.y.z`

!!! warning "Version-bump requirement"
    If you edit `packages/types`, `packages/eslint-config`, or `packages/tsconfig`, bump that package's `package.json` version **in the same PR**. Skipping the bump means consumers won't pick up your change after merge.

## GitHub Actions Secrets

### Required Secrets

| Secret | Description |
|--------|-------------|
| `BETTER_AUTH_SECRET` | Better Auth secret (backend CI only) |

!!! note "Auth secrets"
    `BETTER_AUTH_SECRET` is only needed in the backend CI. The frontend does not require any auth secrets.

## Pull Request Workflow

1. **Create branch** from `main`
2. **Make changes** and commit
3. **Open PR** - CI runs automatically (per-repo)
4. **Review** - Wait for approval
5. **Merge** - Squash and merge to main

### PR Template

PRs should include:

- Summary of changes
- Test plan
- Checklist items

## Local CI Checks

Run the same checks locally before pushing:

```bash
# One install at the monorepo root hydrates every package
pnpm install

# Backend
pnpm --filter @stocket/api lint           # oxlint
pnpm --filter @stocket/api type-check     # TypeScript
pnpm --filter @stocket/api build          # bun build
pnpm --filter @stocket/api test           # Vitest
pnpm --filter @stocket/api test:integration

# Frontend
pnpm --filter @stocket/web lint           # oxlint
pnpm --filter @stocket/web type-check
pnpm --filter @stocket/web build
```

## Deployment

### Documentation

Documentation is automatically deployed via GitHub Pages when changes are pushed to main.

Trigger paths:

- `docs/**`
- `mkdocs.yml`
- `.github/workflows/deploy-docs.yml`

### Application

Docker images are published via `docker-publish.yml` workflows in each repo.

## Troubleshooting

### CI Failures

**Lint errors:**

```bash
pnpm lint --fix
```

**Type errors:**

```bash
# Backend
cd backend && pnpm build

# Frontend
cd frontend && pnpm build
```

**Test failures:**

```bash
cd backend && pnpm test
```

### Cache Issues

Clear GitHub Actions cache:

1. Go to Actions tab
2. Click "Caches" in sidebar
3. Delete relevant caches

## Best Practices

1. **Keep PRs small** - Easier to review
2. **Run checks locally** - Before pushing
3. **Fix CI immediately** - Don't let failures accumulate
4. **Update tests** - When changing functionality
