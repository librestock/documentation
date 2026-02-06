# Configuration de l'environnement

Ce guide vous accompagne dans la configuration de votre environnement de développement local.

## Prérequis

- **Node.js** 22+ (géré par devenv)
- **pnpm** 10+ (géré par devenv)
- **PostgreSQL** 16+ (géré par devenv)
- **Nix** avec flakes activés

## Configuration rapide avec devenv

La méthode recommandée utilise [devenv.sh](https://devenv.sh/) pour une configuration reproductible.

### 1. Installer Nix

```bash
# macOS/Linux
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Installer devenv

```bash
nix-env -iA devenv -f https://github.com/NixOS/nixpkgs/tarball/nixos-unstable
```

### 3. Cloner et configurer

```bash
git clone <repo-url>
cd librestock
devenv up
```

Cela démarre automatiquement :

- PostgreSQL sur le port 5432
- API NestJS sur le port 8080
- Frontend TanStack Start sur le port 3000

## Configuration manuelle

Si vous préférez ne pas utiliser Nix :

### 1. Installer les dépendances

```bash
# Installer pnpm
npm install -g pnpm

# Installer les dépendances du projet
pnpm install
```

### 2. Configurer PostgreSQL

```bash
# Créer la base de données
createdb librestock_inventory
```

### 3. Configurer les variables d'environnement

Créez les fichiers `.env` dans chaque module :

**API (`modules/api/.env`) :**

```bash
DATABASE_URL=postgresql://localhost:5432/librestock_inventory
CLERK_SECRET_KEY=sk_test_xxx
PORT=8080
```

**Web (`modules/web/.env.local`) :**

```bash
VITE_API_BASE_URL=http://localhost:8080
VITE_CLERK_PUBLISHABLE_KEY=pk_test_xxx
```

### 4. Démarrer les services

```bash
# Terminal 1 - API
pnpm --filter @librestock/api start:dev

# Terminal 2 - Web
pnpm --filter @librestock/web dev
```

## Vérification

Une fois lancé, vérifiez :

| Service | URL | Description |
|---------|-----|-------------|
| API | http://localhost:8080/api/docs | Documentation Swagger |
| Web | http://localhost:3000 | Application frontend |
| DB | localhost:5432 | Base PostgreSQL |

## Problèmes courants

### Port déjà utilisé

```bash
# Trouver le processus utilisant le port
lsof -i :8080

# Tuer le processus
kill -9 <PID>
```

### Erreurs de connexion PostgreSQL

Vérifiez que PostgreSQL est en cours d'exécution :

```bash
pg_isready -h localhost -p 5432
```

### Erreurs de dépendances

Nettoyez et réinstallez :

```bash
rm -rf node_modules
pnpm install
```
