# Configuration de l'environnement

Ce guide vous accompagne dans la configuration de votre environnement de développement local.

## Prérequis

- **Node.js** >= 20 (géré par Nix)
- **pnpm** >= 10 (géré par Nix)
- **PostgreSQL** 16 (via Docker Compose)
- **Nix** avec flakes activés
- **1Password CLI** (pour la configuration des variables d'environnement)
- **just** command runner (pour la configuration des variables d'environnement)

## Configuration rapide avec Nix Flakes

Chaque repo possède son propre Nix flake pour un environnement de développement reproductible.

### 1. Installer Nix

```bash
# macOS/Linux
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Cloner et configurer

```bash
git clone https://github.com/librestock/meta.git
cd meta && ./scripts/bootstrap && cd ..
```

### 3. Démarrer les services

```bash
# Démarrer PostgreSQL et autres services via Docker Compose
cd meta && docker compose up -d
```

### 4. Entrer dans le shell de développement

```bash
# Shell de développement backend
cd backend && nix develop

# Shell de développement frontend
cd frontend && nix develop
```

Cela fournit :

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

Créez les fichiers `.env` dans chaque repo :

**Backend (`backend/.env`) :**

```bash
DATABASE_URL=postgresql://localhost:5432/librestock_inventory
BETTER_AUTH_SECRET=votre-secret-ici
PORT=8080
```

**Frontend (`frontend/.env.local`) :**

```bash
VITE_API_BASE_URL=http://localhost:8080/api/v1
```

!!! note "Secret Better Auth"
    `BETTER_AUTH_SECRET` ne doit se trouver que dans le `.env` du backend -- jamais dans le frontend.

### 4. Démarrer les services

```bash
# Terminal 1 - Backend
cd backend
pnpm start:dev

# Terminal 2 - Frontend
cd frontend
pnpm dev
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
rm -rf backend/node_modules
rm -rf frontend/node_modules
pnpm install
```
