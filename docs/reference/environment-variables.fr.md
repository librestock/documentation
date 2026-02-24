# Variables d'environnement

Référence complète de toutes les variables d'environnement utilisées dans LibreStock Inventory.

## Backend API

Emplacement : `backend/.env`

### Base de données

| Variable | Requis | Description | Exemple |
|----------|--------|-------------|---------|
| `DATABASE_URL` | Oui* | Chaîne de connexion PostgreSQL complète | `postgresql://postgres:postgres@localhost:5432/librestock_inventory` |
| `PGHOST` | Oui* | Hôte PostgreSQL | `localhost` |
| `PGPORT` | Oui* | Port PostgreSQL | `5432` |
| `PGUSER` | Oui* | Utilisateur PostgreSQL | `postgres` |
| `PGPASSWORD` | Oui* | Mot de passe PostgreSQL | `postgres` |
| `PGDATABASE` | Oui* | Nom de la base PostgreSQL | `librestock_inventory` |

*Soit `DATABASE_URL` soit les variables `PG*` individuelles sont requises.

### Authentification

| Variable | Requis | Description | Exemple |
|----------|--------|-------------|---------|
| `BETTER_AUTH_SECRET` | Oui | Chaîne aléatoire de 32+ octets pour la signature de session | `<sortie de openssl rand -base64 32>` |
| `BETTER_AUTH_URL` | Oui | URL du serveur backend pour Better Auth | `http://localhost:8080` |

### Serveur

| Variable | Requis | Défaut | Description |
|----------|--------|--------|-------------|
| `PORT` | Non | `8080` | Port du serveur API |
| `NODE_ENV` | Non | `development` | Mode d'environnement |
| `CORS_ORIGIN` | Non | `http://localhost:3000` | Origine CORS autorisée |
| `FRONTEND_URL` | Non | `http://localhost:3000` | URL du frontend pour les redirections |

### Exemple `.env`

```bash
# Base de données
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/librestock_inventory

# Authentification
BETTER_AUTH_SECRET=<chaîne aléatoire de 32+ octets>
BETTER_AUTH_URL=http://localhost:8080

# Serveur
PORT=8080
NODE_ENV=development
CORS_ORIGIN=http://localhost:3000
FRONTEND_URL=http://localhost:3000
```

## Frontend Web

Emplacement : `frontend/.env`

### API

| Variable | Requis | Description | Exemple |
|----------|--------|-------------|---------|
| `VITE_API_BASE_URL` | Oui | URL de l'API backend | `http://localhost:8080/api/v1` |

### Monitoring

| Variable | Requis | Description | Exemple |
|----------|--------|-------------|---------|
| `VITE_SENTRY_DSN` | Non | DSN Sentry pour le suivi des erreurs | `https://xxx@sentry.io/xxx` |
| `SENTRY_AUTH_TOKEN` | Non | Token d'authentification Sentry pour les source maps | `sntrys_xxx...` |

### Exemple `.env`

```bash
# API
VITE_API_BASE_URL=http://localhost:8080/api/v1

# Monitoring (optionnel)
VITE_SENTRY_DSN=<dsn sentry>
SENTRY_AUTH_TOKEN=<token auth sentry>
```

## Configuration des fichiers d'environnement

**Backend :**

```bash
cp backend/.env.template backend/.env
```

**Frontend :**

```bash
echo "VITE_API_BASE_URL=http://localhost:8080/api/v1" > frontend/.env
```

!!!tip "1Password CLI"
    Les deux dépôts disposent d'un `justfile` avec une tâche `decrypt` utilisant 1Password CLI :
    ```bash
    cd backend && just decrypt
    cd frontend && just decrypt
    ```
    Ceci exécute `op inject -i env.template -o .env` pour injecter les secrets depuis 1Password.

## Secrets CI/CD

Secrets GitHub Actions requis pour la CI/CD :

| Secret | Description |
|--------|-------------|
| `BETTER_AUTH_SECRET` | Secret Better Auth pour les tests CI |

## Déploiement de la documentation

La documentation est déployée via GitHub Pages :

- **URL du site :** https://librestock.github.io/documentation/
- **Dépôt :** https://github.com/librestock/documentation

## Considérations de production

### Sécurité

- Ne jamais committer les fichiers `.env`
- Utiliser la gestion de secrets en production
- Faire une rotation des clés régulièrement

### Better Auth

- Utiliser un `BETTER_AUTH_SECRET` fort et unique en production (32+ octets aléatoires)
- Définir `BETTER_AUTH_URL` vers l'URL de votre backend de production

### Base de données

- Utiliser le connection pooling en production
- Activer SSL pour les connexions à la base de données
