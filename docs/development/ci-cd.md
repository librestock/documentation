# CI/CD

This guide covers the GitHub Actions workflows and deployment processes for LibreStock Inventory.

## Workflows

### CI Pipeline

**File:** `.github/workflows/ci.yml`

Runs on every pull request and push to main:

- Lint all packages
- Type check
- Run tests
- Build all packages
- Build shared types

### Documentation Deployment

**File:** `.github/workflows/deploy-docs.yml`

Deploys documentation to AWS S3 + CloudFront on push to main.

## GitHub Actions Secrets

### Required Secrets

| Secret | Description |
|--------|-------------|
| `CLERK_SECRET_KEY` | Clerk authentication |
| `AWS_DOCS_ROLE_ARN` | IAM role for docs deployment |
| `DOCS_S3_BUCKET` | S3 bucket name |
| `DOCS_CLOUDFRONT_DISTRIBUTION_ID` | CloudFront distribution |

## Pull Request Workflow

1. **Create branch** from `main`
2. **Make changes** and commit
3. **Open PR** - CI runs automatically
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
# Install dependencies
pnpm install

# Lint
pnpm lint

# Type check
pnpm build

# Test
pnpm test

# Build docs
pnpm docs:build
```

## Deployment

### Documentation

Documentation is automatically deployed when changes are pushed to main.

Trigger paths:

- `docs/**`
- `mkdocs.yml`
- `.github/workflows/deploy-docs.yml`

### Application

Application deployment is not yet automated. See [Roadmap](../roadmap.md) for planned features.

## Troubleshooting

### CI Failures

**Lint errors:**

```bash
pnpm lint --fix
```

**Type errors:**

```bash
pnpm --filter @librestock/api build
pnpm --filter @librestock/web build
```

**Test failures:**

```bash
pnpm test -- --verbose
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
