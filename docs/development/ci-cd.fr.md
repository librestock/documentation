# CI/CD

Ce guide couvre les workflows GitHub Actions et les processus de déploiement pour LibreStock Inventory.

## Workflows

Les workflows CI sont **par repo**, pas au niveau racine du workspace.

### Pipeline CI Backend

**Fichier :** `backend/.github/workflows/ci.yml`

S'exécute à chaque pull request et push sur main :

- Lint
- Vérification des types
- Exécution des tests unitaires
- Exécution des tests E2E
- Build

### Pipeline CI Frontend

**Fichier :** `frontend/.github/workflows/ci.yml`

S'exécute à chaque pull request et push sur main :

- Lint
- Vérification des types
- Build

### Publication Docker

Chaque repo possède son propre workflow de publication Docker :

- **Backend :** `backend/.github/workflows/docker-publish.yml`
- **Frontend :** `frontend/.github/workflows/docker-publish.yml`

### Déploiement de la documentation

**Fichier :** `documentation/.github/workflows/deploy-docs.yml`

Déploie la documentation via GitHub Pages lors d'un push sur main.

## Secrets GitHub Actions

### Secrets requis

| Secret | Description |
|--------|-------------|
| `BETTER_AUTH_SECRET` | Secret Better Auth (CI backend uniquement) |

!!! note "Secrets d'authentification"
    `BETTER_AUTH_SECRET` n'est nécessaire que dans le CI du backend. Le frontend ne nécessite aucun secret d'authentification.

## Workflow Pull Request

1. **Créer une branche** depuis `main`
2. **Faire des modifications** et committer
3. **Ouvrir une PR** - CI s'exécute automatiquement (par repo)
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

## Déploiement

### Documentation

La documentation est automatiquement déployée via GitHub Pages quand des changements sont pushés sur main.

Chemins déclencheurs :

- `docs/**`
- `mkdocs.yml`
- `.github/workflows/deploy-docs.yml`

### Application

Les images Docker sont publiées via les workflows `docker-publish.yml` dans chaque repo.

## Dépannage

### Échecs CI

**Erreurs de lint :**

```bash
pnpm lint --fix
```

**Erreurs de type :**

```bash
# Backend
cd backend && pnpm build

# Frontend
cd frontend && pnpm build
```

**Échecs de tests :**

```bash
cd backend && pnpm test -- --verbose
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
