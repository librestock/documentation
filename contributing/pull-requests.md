# Pull Request Process

This guide explains how to create and manage pull requests for LibreStock Inventory.

## Creating a Pull Request

### Prerequisites

Before creating a PR:

1. **Tests pass locally**
   ```bash
   pnpm test
   ```

2. **Linting passes**
   ```bash
   pnpm lint
   ```

3. **Build succeeds**
   ```bash
   pnpm build
   ```

4. **Branch is up to date**
   ```bash
   git fetch origin
   git rebase origin/main
   ```

### PR Template

When creating a PR, include:

```markdown
## Summary

Brief description of the changes.

## Changes

- Added X feature
- Fixed Y bug
- Updated Z documentation

## Test Plan

- [ ] Unit tests added/updated
- [ ] Manual testing performed
- [ ] Documentation updated

## Screenshots (if applicable)

[Add screenshots for UI changes]
```

## Review Process

### 1. Automated Checks

When you open a PR, the following checks run automatically:

- **Linting** - Code style validation
- **Type checking** - TypeScript compilation
- **Tests** - Unit and integration tests
- **Build** - Ensure all packages build

All checks must pass before merging.

### 2. Code Review

- At least one approval is required
- Reviewers will check:
    - Code quality and style
    - Test coverage
    - Documentation updates
    - Security considerations

### 3. Addressing Feedback

- Respond to all comments
- Push additional commits to address feedback
- Request re-review after changes

## Merging

Once approved:

1. **Squash and merge** - Default merge strategy
2. **Delete branch** - Clean up after merge
3. **CI runs on main** - Verify the merge

## Best Practices

### Keep PRs Small

- Easier to review
- Faster to merge
- Less risk of conflicts

### Write Clear Descriptions

- Explain the "why", not just the "what"
- Link to related issues
- Include context for reviewers

### Respond Promptly

- Address feedback quickly
- Keep the conversation moving
- Ask questions if unclear

### Update Documentation

- README changes if needed
- API documentation for new endpoints
- User guide for new features

## Handling Merge Conflicts

If conflicts arise:

```bash
# Update your branch
git fetch origin
git rebase origin/main

# Resolve conflicts
# Edit conflicting files
git add <resolved-files>
git rebase --continue

# Force push (only for PR branches)
git push --force-with-lease
```

## After Merging

- Delete your feature branch
- Verify CI passes on main
- Check the deployment (if applicable)
