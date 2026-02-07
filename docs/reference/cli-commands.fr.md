# Commandes CLI

Référence de toutes les commandes disponibles en ligne de commande pour LibreStock Inventory.

## Gestionnaire de paquets

Toutes les commandes utilisent pnpm. Exécutez depuis la racine du repository.

## Commandes racine

### Installation

```bash
# Installer toutes les dépendances
pnpm install

# Installation propre (supprimer node_modules d'abord)
rm -rf node_modules && pnpm install
```

### Développement

```bash
# Démarrer tous les services avec devenv
devenv up

# Build tous les packages
pnpm build

# Lint tous les packages
pnpm lint

# Exécuter tous les tests
pnpm test
```

### Documentation

```bash
# Servir la doc localement
pnpm docs:dev

# Build la doc (avec mode strict)
pnpm docs:build
```

## Commandes du module API

Utilisez `pnpm --filter @librestock/api <commande>` ou exécutez depuis `modules/api/`.

### Développement

```bash
# Démarrer le serveur de développement avec hot reload
pnpm --filter @librestock/api start:dev

# Démarrer le serveur de production
pnpm --filter @librestock/api start:prod

# Build l'application
pnpm --filter @librestock/api build
```

### Tests

```bash
# Exécuter les tests unitaires
pnpm --filter @librestock/api test

# Exécuter les tests en mode watch
pnpm --filter @librestock/api test:watch

# Exécuter les tests avec couverture
pnpm --filter @librestock/api test:cov

# Exécuter les tests end-to-end
pnpm --filter @librestock/api test:e2e
```

### Qualité du code

```bash
# Lint le code
pnpm --filter @librestock/api lint

# Lint et corriger
pnpm --filter @librestock/api lint --fix
```

### Types partagés

```bash
# Build des types partagés
pnpm --filter @librestock/types build
```

## Commandes du module Web

Utilisez `pnpm --filter @librestock/web <commande>` ou exécutez depuis `modules/web/`.

### Développement

```bash
# Démarrer le serveur de développement
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
```


## Commandes Devenv

Lors de l'utilisation de devenv :

```bash
# Démarrer tous les services (PostgreSQL, API, Web)
devenv up

# Entrer dans le shell devenv
devenv shell

# Exécuter un processus spécifique
devenv processes up api
devenv processes up web
devenv processes up docs
```

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
pnpm --filter @librestock/types build
```
