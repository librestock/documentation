# CI/CD

This guide covers the GitHub Actions workflows and deployment processes for LibreStock Inventory.

## Workflows

CI workflows are **per-repo**, not at the workspace root level.

### Backend CI Pipeline

**File:** `backend/.github/workflows/ci.yml`

Runs on every pull request and push to main:

- Lint
- Type check
- Run unit tests
- Run E2E tests
- Build

### Frontend CI Pipeline

**File:** `frontend/.github/workflows/ci.yml`

Runs on every pull request and push to main:

- Lint
- Type check
- Build

### Docker Publish

Each repo has its own Docker publish workflow:

- **Backend:** `backend/.github/workflows/docker-publish.yml`
- **Frontend:** `frontend/.github/workflows/docker-publish.yml`

### Documentation Deployment

**File:** `documentation/.github/workflows/deploy-docs.yml`

Deploys documentation via GitHub Pages on push to main.

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
# Backend
cd backend
pnpm install
pnpm lint
pnpm build
pnpm test

# Frontend
cd frontend
pnpm install
pnpm lint
pnpm build
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
cd backend && pnpm test -- --verbose
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
