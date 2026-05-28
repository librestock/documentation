# Commandes CLI

Référence de toutes les commandes disponibles en ligne de commande pour Stocket Inventory.

## Gestionnaire de paquets

Toutes les commandes utilisent pnpm. Exécutez depuis la racine du repository ou utilisez le flag `--filter`.

## Commandes Backend

Utilisez `pnpm --filter @stocket/api <commande>` ou `cd backend && pnpm <commande>`.

### Développement

```bash
# Démarrer le serveur de développement (Bun)
pnpm --filter @stocket/api start

# Build l'application (bun build)
pnpm --filter @stocket/api build

# Démarrer le serveur de production
pnpm --filter @stocket/api start:prod
```

### Tests

```bash
# Exécuter les tests unitaires (Vitest)
pnpm --filter @stocket/api test

# Exécuter les tests en mode watch
pnpm --filter @stocket/api test:watch

# Exécuter les tests avec couverture
pnpm --filter @stocket/api test:cov

# Exécuter les tests d'intégration
pnpm --filter @stocket/api test:integration
```

### Qualité du code

```bash
# Lint le code
pnpm --filter @stocket/api lint

# Formater le code avec Prettier
pnpm --filter @stocket/api format

# Vérification de types TypeScript
pnpm --filter @stocket/api type-check
```

### Base de données

```bash
# Alimenter la base de données avec des données d'exemple
pnpm --filter @stocket/api seed

# Importer depuis Sortly
pnpm --filter @stocket/api import:sortly
```

!!! note "Migrations"
    Le schéma de la base de données est géré via Drizzle ORM. Les changements de schéma sont définis dans `backend/src/effect/platform/db/schema.ts` et appliqués automatiquement au démarrage en développement.

## Commandes Frontend

Utilisez `pnpm --filter @stocket/web <commande>` ou `cd frontend && pnpm <commande>`.

### Développement

```bash
# Démarrer le serveur de développement (port 3000)
pnpm --filter @stocket/web dev

# Build pour la production
pnpm --filter @stocket/web build

# Démarrer le serveur de production
pnpm --filter @stocket/web start
```

### Qualité du code

```bash
# Lint le code
pnpm --filter @stocket/web lint

# Lint et corriger
pnpm --filter @stocket/web lint:fix

# Vérification de types TypeScript
pnpm --filter @stocket/web type-check

# Exécuter toutes les validations (type-check + lint + format check)
pnpm --filter @stocket/web validate

# Prettier write + ESLint fix
pnpm --filter @stocket/web check
```

### Tests

```bash
# Exécuter les tests E2E Playwright
pnpm --filter @stocket/web test:e2e

# Mode UI Playwright
pnpm --filter @stocket/web test:e2e:ui

# Tests en navigateur visible
pnpm --filter @stocket/web test:e2e:headed
```

## Types partagés

```bash
# Générer les fichiers barrel
pnpm --filter @stocket/types barrels

# Build des types partagés
pnpm --filter @stocket/types build
```

## Commandes du Workspace Meta

Exécutez depuis le répertoire `meta/` :

```bash
# Synchroniser les dépôts + installer les dépendances
./scripts/bootstrap

# Démarrer les serveurs de développement backend + frontend
./scripts/dev

# Démarrer également les services Docker (PostgreSQL, etc.)
./scripts/dev --with-docker

# Synchroniser les dépôts depuis repos.yaml
./scripts/clone-or-update

# Alternative : utiliser workspace.mjs directement
node scripts/workspace.mjs sync
node scripts/workspace.mjs bootstrap
node scripts/workspace.mjs dev [--include-desktop] [--include-docs] [--with-docker]
```

## Docker Compose

Démarrer les services de développement (PostgreSQL) :

```bash
docker compose -f meta/docker-compose.yml up -d
```

## Commandes Just

Le backend et le frontend disposent d'un `justfile`. Nécessite le lanceur de commandes [`just`](https://github.com/casey/just).

```bash
# Installer les dépendances
just bootstrap

# Exporter les variables d'environnement avec Infisical CLI
just env

# Démarrer le serveur de développement
just dev

# Build pour la production
just build

# Exécuter les tests
just test
```

!!!tip "Infisical CLI"
    La commande `just env` exécute `infisical export --env=dev --format=dotenv > .env` pour générer les fichiers `.env` à partir des templates en utilisant Infisical CLI.

## Commandes Base de données

Avec PostgreSQL en cours d'exécution :

```bash
# Se connecter à la base de données
psql -h localhost -p 5432 -U postgres -d stocket_inventory

# Vérifier le statut de la base
pg_isready -h localhost -p 5432
```

## Combinaisons utiles

```bash
# Rebuild complet
pnpm install && pnpm build

# Vérification pré-commit
pnpm lint && pnpm test && pnpm build

# Mettre à jour les types partagés après des changements backend
pnpm --filter @stocket/types barrels && pnpm --filter @stocket/types build
```
