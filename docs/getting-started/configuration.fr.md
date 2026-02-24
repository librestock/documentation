# Configuration

Ce guide couvre toutes les options de configuration pour LibreStock Inventory.

## Variables d'Environnement

### Backend API

Situé dans `backend/.env` :

| Variable | Requis | Description |
|----------|--------|-------------|
| `DATABASE_URL` | Oui | Chaîne de connexion PostgreSQL |
| `NODE_ENV` | Non | Mode d'environnement (défaut : `development`) |
| `PORT` | Non | Port API (défaut : `8080`) |
| `CORS_ORIGIN` | Non | Origine CORS autorisée (défaut : `http://localhost:3000`) |
| `BETTER_AUTH_SECRET` | Oui | Chaîne aléatoire de 32+ octets pour la signature de session Better Auth |
| `BETTER_AUTH_URL` | Oui | URL du serveur Better Auth (ex : `http://localhost:8080`) |
| `FRONTEND_URL` | Non | URL du frontend pour les redirections (défaut : `http://localhost:3000`) |

Les variables de base de données individuelles sont également supportées : `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`.

**Exemple :**

```bash
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/librestock_inventory
NODE_ENV=development
PORT=8080
CORS_ORIGIN=http://localhost:3000
BETTER_AUTH_SECRET=<chaîne aléatoire de 32+ octets>
BETTER_AUTH_URL=http://localhost:8080
FRONTEND_URL=http://localhost:3000
```

### Frontend Web

Situé dans `frontend/.env` :

| Variable | Requis | Description |
|----------|--------|-------------|
| `VITE_API_BASE_URL` | Oui | URL de l'API backend |
| `VITE_SENTRY_DSN` | Non | DSN Sentry pour le suivi des erreurs |
| `SENTRY_AUTH_TOKEN` | Non | Token d'authentification Sentry pour les source maps |

**Exemple :**

```bash
VITE_API_BASE_URL=http://localhost:8080/api/v1
VITE_SENTRY_DSN=<dsn sentry>
SENTRY_AUTH_TOKEN=<token auth sentry>
```

## Authentification Better Auth

Better Auth est configuré uniquement dans le backend. Le `BETTER_AUTH_SECRET` doit être une chaîne aléatoire d'au moins 32 octets. Vous pouvez en générer un avec :

```bash
openssl rand -base64 32
```

`BETTER_AUTH_URL` doit pointer vers l'URL du serveur backend où les endpoints Better Auth sont servis.

!!!note
    `BETTER_AUTH_SECRET` ne se trouve que dans le `.env` du backend -- il n'est jamais défini dans le frontend.

## Configuration de la Base de Données

### Utilisation de Docker Compose (Recommandé)

PostgreSQL est fourni par Docker Compose :

```bash
docker compose -f meta/docker-compose.yml up -d
```

Configuration par défaut :

- Nom de la base : `librestock_inventory`
- Hôte : `localhost`
- Port : `5432`
- Utilisateur : `postgres`
- Mot de passe : `postgres`

### Configuration Manuelle

Créez la base de données :

```bash
createdb librestock_inventory
```

Définissez la chaîne de connexion :

```bash
DATABASE_URL=postgresql://username:password@localhost:5432/librestock_inventory
```

## Documentation API

Swagger UI est disponible sur :

- http://localhost:8080/api/docs
- OpenAPI JSON : http://localhost:8080/api/docs-json

## Prochaines Étapes

- [Architecture](../development/architecture.md) - Comprendre la conception du système
- [Configuration de développement](../development/setup.md) - Configuration pour le développement
