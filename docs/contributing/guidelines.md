# Contribution Guidelines

This document outlines the guidelines for contributing to LibreStock Inventory.

## Development Workflow

### 1. Fork and Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/YOUR-USERNAME/librestock.git
cd librestock
```

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-description
```

### 3. Make Changes

- Follow the [code style guide](../development/code-style.md)
- Write tests for new functionality
- Update documentation as needed

### 4. Test Your Changes

```bash
# Run linting
pnpm lint

# Run tests
pnpm test

# Build to check for type errors
pnpm build
```

### 5. Commit Your Changes

Use clear, descriptive commit messages:

```bash
git commit -m "feat: add product search functionality"
git commit -m "fix: resolve category deletion error"
git commit -m "docs: update API development guide"
```

Follow [Conventional Commits](https://www.conventionalcommits.org/) format:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

### 6. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then create a pull request on GitHub.

## Code Standards

### TypeScript

- Use strict TypeScript
- Provide types for all function parameters and return values
- Avoid `any` type

### API Development

- Follow the [API development guide](../development/api-development.md)
- Add Swagger decorators for new endpoints
- Include validation decorators on DTOs

### Frontend Development

- Follow the [frontend development guide](../development/frontend-development.md)
- Prefer server components when possible
- Use generated API hooks

### Testing

- Write unit tests for new functionality
- Follow the [testing guide](../development/testing.md)
- Aim for meaningful test coverage

## Documentation

When contributing:

- Update relevant documentation
- Add JSDoc comments for public APIs
- Include examples for complex functionality

## Review Process

1. **Automated checks** - CI must pass
2. **Code review** - At least one approval required
3. **Documentation review** - For significant changes
4. **Merge** - Squash and merge to main

## Getting Help

- Check existing issues and documentation
- Ask questions in your PR
- Reach out to maintainers
