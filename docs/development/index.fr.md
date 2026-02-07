# Développement

Cette section couvre tout ce dont vous avez besoin pour contribuer à la base de code LibreStock Inventory.

## Aperçu

LibreStock Inventory est un monorepo pnpm contenant :

- **@librestock/api** - Backend NestJS
- **@librestock/web** - Frontend TanStack Start

## Liens Rapides

- [Architecture](architecture.md) - Conception du système et stack technique
- [Configuration](setup.md) - Configuration de l'environnement de développement
- [Style de Code](code-style.md) - ESLint, Prettier et conventions
- [Tests](testing.md) - Patterns de tests Jest
- [Développement API](api-development.md) - Patterns NestJS
- [Développement Frontend](frontend-development.md) - Patterns TanStack Start
- [CI/CD](ci-cd.md) - Workflows GitHub Actions

## Flux de Travail de Développement

1. **Démarrer l'environnement**

    ```bash
    devenv up
    ```

2. **Effectuer les modifications** dans la base de code

3. **Mettre à jour les types partagés** (si les DTO ont changé)

    ```bash
    pnpm --filter @librestock/types build
    ```

4. **Exécuter les tests et le lint**

    ```bash
    pnpm test
    pnpm lint
    ```

5. **Soumettre une pull request**
