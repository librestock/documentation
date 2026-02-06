# Installation

Ce guide couvre la configuration de l'environnement de développement LibreStock Inventory.

## Utilisation de devenv (Recommandé)

Le projet utilise [devenv.sh](https://devenv.sh) pour des environnements de développement reproductibles.

### 1. Installer Nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### 2. Installer devenv

```bash
nix profile install nixpkgs#devenv
```

### 3. Cloner et Entrer dans l'Environnement

```bash
git clone https://github.com/maximilianpw/librestock-inventory.git
cd librestock-inventory
devenv shell
```

Ceci va :

- Installer Node.js 24 et pnpm 10
- Installer Python 3.12 avec MkDocs
- Configurer PostgreSQL 16
- Configurer toutes les variables d'environnement

### 4. Installer les Dépendances

```bash
pnpm install
```

### 5. Démarrer les Services de Développement

```bash
devenv up
```

Ceci démarre :

| Service | URL | Description |
|---------|-----|-------------|
| PostgreSQL | localhost:5432 | Base de données |
| NestJS API | http://localhost:8080 | Backend + Swagger |
| TanStack Start Web | http://localhost:3000 | Frontend |
| MkDocs | http://localhost:8000 | Documentation |

## Configuration Manuelle (Alternative)

Si vous préférez ne pas utiliser devenv :

### Prérequis

- Node.js >= 20.0.0
- pnpm >= 10.0.0
- PostgreSQL 16
- Python 3.12 (pour la documentation)

### Configuration de la Base de Données

```bash
createdb librestock_inventory
```

### Variables d'Environnement

Copiez le modèle d'environnement :

```bash
cp modules/api/.env.template modules/api/.env
```

Modifiez `.env` avec votre configuration :

```bash
DATABASE_URL=postgresql://user@localhost:5432/librestock_inventory
CLERK_SECRET_KEY=sk_test_...
PORT=8080
```

### Démarrer les Services

```bash
# Terminal 1: API
cd modules/api && pnpm start:dev

# Terminal 2: Web
cd modules/web && pnpm dev
```

## Vérifier l'Installation

1. Ouvrez http://localhost:8080/api/docs - Vous devriez voir Swagger UI
2. Ouvrez http://localhost:3000 - Vous devriez voir la page de connexion

## Prochaines Étapes

- [Démarrage rapide](quick-start.md) - Créer vos premiers produits
- [Configuration](configuration.md) - En savoir plus sur les options de configuration
