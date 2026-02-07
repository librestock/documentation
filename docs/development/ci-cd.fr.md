# CI/CD

Ce guide couvre les workflows GitHub Actions et les processus de déploiement pour LibreStock Inventory.

## Workflows

### Pipeline CI

**Fichier :** `.github/workflows/ci.yml`

S'exécute à chaque pull request et push sur main :

- Lint de tous les packages
- Vérification des types
- Exécution des tests
- Build de tous les packages
- Build des types partagés

### Déploiement de la documentation

**Fichier :** `.github/workflows/deploy-docs.yml`

Déploie la documentation sur AWS S3 + CloudFront lors d'un push sur main.

## Secrets GitHub Actions

### Secrets requis

| Secret | Description |
|--------|-------------|
| `CLERK_SECRET_KEY` | Authentification Clerk |
| `AWS_DOCS_ROLE_ARN` | Rôle IAM pour le déploiement docs |
| `DOCS_S3_BUCKET` | Nom du bucket S3 |
| `DOCS_CLOUDFRONT_DISTRIBUTION_ID` | Distribution CloudFront |

## Workflow Pull Request

1. **Créer une branche** depuis `main`
2. **Faire des modifications** et committer
3. **Ouvrir une PR** - CI s'exécute automatiquement
4. **Review** - Attendre l'approbation
5. **Merger** - Squash and merge vers main

### Template de PR

Les PRs doivent inclure :

- Résumé des changements
- Plan de test
- Éléments de checklist

## Vérifications CI locales

Exécuter les mêmes vérifications localement avant de pusher :

```bash
# Installer les dépendances
pnpm install

# Lint
pnpm lint

# Vérification des types
pnpm build

# Test
pnpm test

# Build docs
pnpm docs:build
```

## Déploiement

### Documentation

La documentation est automatiquement déployée quand des changements sont pushés sur main.

Chemins déclencheurs :

- `docs/**`
- `mkdocs.yml`
- `.github/workflows/deploy-docs.yml`

### Application

Le déploiement de l'application n'est pas encore automatisé. Voir [Feuille de route](../roadmap.md) pour les fonctionnalités planifiées.

## Dépannage

### Échecs CI

**Erreurs de lint :**

```bash
pnpm lint --fix
```

**Erreurs de type :**

```bash
pnpm --filter @librestock/api build
pnpm --filter @librestock/web build
```

**Échecs de tests :**

```bash
pnpm test -- --verbose
```

### Problèmes de cache

Vider le cache GitHub Actions :

1. Aller dans l'onglet Actions
2. Cliquer sur "Caches" dans la barre latérale
3. Supprimer les caches concernés

## Bonnes pratiques

1. **Garder les PRs petites** - Plus faciles à review
2. **Exécuter les vérifications localement** - Avant de pusher
3. **Corriger la CI immédiatement** - Ne pas laisser les échecs s'accumuler
4. **Mettre à jour les tests** - Quand on modifie les fonctionnalités
