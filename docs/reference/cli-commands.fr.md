# Commandes CLI

Référence de toutes les commandes disponibles en ligne de commande pour LibreStock Inventory.

## Gestionnaire de paquets

Toutes les commandes utilisent pnpm. Exécutez depuis la racine du repository ou utilisez le flag `--filter`.

## Commandes Backend

Utilisez `pnpm --filter @librestock/api <commande>` ou `cd backend && pnpm <commande>`.

### Développement

```bash
# Démarrer le serveur de développement avec hot reload
pnpm --filter @librestock/api start:dev

# Démarrer en mode debug
pnpm --filter @librestock/api start:debug

# Build l'application
pnpm --filter @librestock/api build

# Démarrer le serveur de production
pnpm --filter @librestock/api start:prod
```

### Tests

```bash
# Exécuter les tests unitaires (Jest 30)
pnpm --filter @librestock/api test

# Exécuter les tests en mode watch
pnpm --filter @librestock/api test:watch

# Exécuter les tests avec couverture
pnpm --filter @librestock/api test:cov

# Exécuter les tests end-to-end
pnpm --filter @librestock/api test:e2e

# Déboguer les tests
pnpm --filter @librestock/api test:debug
```

### Qualité du code

```bash
# Lint le code
pnpm --filter @librestock/api lint

# Formater le code avec Prettier
pnpm --filter @librestock/api format

# Vérification de types TypeScript
pnpm --filter @librestock/api type-check
```

### Base de données

```bash
# Alimenter la base de données
pnpm --filter @librestock/api seed

# Importer depuis Sortly
pnpm --filter @librestock/api import:sortly

# Générer une migration TypeORM
pnpm --filter @librestock/api migration:generate

# Exécuter les migrations en attente
pnpm --filter @librestock/api migration:run

# Annuler la dernière migration
pnpm --filter @librestock/api migration:revert
```

## Commandes Frontend

Utilisez `pnpm --filter @librestock/web <commande>` ou `cd frontend && pnpm <commande>`.

### Développement

```bash
# Démarrer le serveur de développement (port 3000)
pnpm --filter @librestock/web dev

# Build pour la production
pnpm --filter @librestock/web build

# Démarrer le serveur de production
pnpm --filter @librestock/web start
```

### Qualité du code

```bash
# Lint le code
pnpm --filter @librestock/web lint

# Lint et corriger
pnpm --filter @librestock/web lint:fix

# Vérification de types TypeScript
pnpm --filter @librestock/web type-check

# Exécuter toutes les validations (type-check + lint + format check)
pnpm --filter @librestock/web validate

# Prettier write + ESLint fix
pnpm --filter @librestock/web check
```

### Tests

```bash
# Exécuter les tests E2E Playwright
pnpm --filter @librestock/web test:e2e

# Mode UI Playwright
pnpm --filter @librestock/web test:e2e:ui

# Tests en navigateur visible
pnpm --filter @librestock/web test:e2e:headed
```

## Types partagés

```bash
# Générer les fichiers barrel
pnpm --filter @librestock/types barrels

# Build des types partagés
pnpm --filter @librestock/types build
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

# Déchiffrer les variables d'environnement avec 1Password CLI
just decrypt

# Démarrer le serveur de développement
just dev

# Build pour la production
just build

# Exécuter les tests
just test
```

!!!tip "1Password CLI"
    La commande `just decrypt` exécute `op inject -i env.template -o .env` pour générer les fichiers `.env` à partir des templates en utilisant 1Password CLI.

## Commandes Base de données

Avec PostgreSQL en cours d'exécution :

```bash
# Se connecter à la base de données
psql -h localhost -p 5432 -U postgres -d librestock_inventory

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
pnpm --filter @librestock/types barrels && pnpm --filter @librestock/types build
```
