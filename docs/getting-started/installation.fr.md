# Installation

Ce guide couvre la configuration de l'environnement de développement LibreStock Inventory.

## Utilisation de Nix Flakes + Docker (Recommandé)

Le projet utilise des [Nix flakes](https://nixos.wiki/wiki/Flakes) par dépôt pour des environnements de développement reproductibles et Docker Compose pour les services comme PostgreSQL.

### 1. Installer Nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Assurez-vous que les flakes sont activés dans votre configuration Nix.

### 2. Cloner le Workspace

```bash
git clone https://github.com/librestock/meta.git
cd meta && ./scripts/bootstrap && cd ..
```

### 3. Initialiser le Workspace

```bash
./meta/scripts/bootstrap
```

Ceci synchronise tous les dépôts et installe les dépendances.

### 4. Entrer dans un Shell Nix (par dépôt)

Chaque dépôt (backend, frontend, etc.) possède son propre `flake.nix`. Entrez dans le shell du dépôt souhaité :

```bash
cd backend && nix develop
# ou
cd frontend && nix develop
```

Ceci fournit :

- Node.js 20+ et pnpm 10
- Tous les outils spécifiques au dépôt

### 5. Démarrer les Services de Développement

Démarrez PostgreSQL et les autres services via Docker Compose :

```bash
docker compose -f meta/docker-compose.yml up -d
```

Ou utilisez le script meta dev pour tout démarrer (serveurs de développement backend + frontend) :

```bash
./meta/scripts/dev
```

Pour démarrer également les services Docker automatiquement :

```bash
./meta/scripts/dev --with-docker
```

Ceci démarre :

| Service | URL | Description |
|---------|-----|-------------|
| PostgreSQL | localhost:5432 | Base de données |
| NestJS API | http://localhost:8080 | Backend + Swagger |
| TanStack Start Web | http://localhost:3000 | Frontend |

### 6. Configurer les Variables d'Environnement

**Backend :**

```bash
cp backend/.env.template backend/.env
```

Modifiez `backend/.env` avec votre configuration :

```bash
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/librestock_inventory
NODE_ENV=development
PORT=8080
CORS_ORIGIN=http://localhost:3000
BETTER_AUTH_SECRET=<chaîne aléatoire de 32+ octets>
BETTER_AUTH_URL=http://localhost:8080
FRONTEND_URL=http://localhost:3000
```

**Frontend :**

```bash
echo "VITE_API_BASE_URL=http://localhost:8080/api/v1" > frontend/.env
```

!!!tip "1Password CLI"
    Le backend et le frontend disposent d'un `justfile` avec une tâche `decrypt`. Si vous utilisez 1Password CLI, vous pouvez générer les fichiers `.env` automatiquement :
    ```bash
    cd backend && just decrypt
    cd frontend && just decrypt
    ```
    Ceci exécute `op inject -i env.template -o .env` pour injecter les secrets depuis 1Password.

## Configuration Manuelle (Alternative)

Si vous préférez ne pas utiliser Nix :

### Prérequis

- Node.js >= 20
- pnpm >= 10
- PostgreSQL 16
- Python 3.12 (pour la documentation)

### Configuration de la Base de Données

```bash
createdb librestock_inventory
```

### Variables d'Environnement

Copiez le modèle d'environnement :

```bash
cp backend/.env.template backend/.env
```

Modifiez `backend/.env` avec votre configuration (voir le tableau ci-dessus).

### Démarrer les Services

```bash
# Terminal 1 : API
cd backend && pnpm start:dev

# Terminal 2 : Web
cd frontend && pnpm dev
```

## Vérifier l'Installation

1. Ouvrez http://localhost:8080/api/docs - Vous devriez voir Swagger UI
2. Ouvrez http://localhost:3000 - Vous devriez voir la page de connexion

## Prochaines Étapes

- [Démarrage rapide](quick-start.md) - Créer vos premiers produits
- [Configuration](configuration.md) - En savoir plus sur les options de configuration
