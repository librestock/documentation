# Variables d'environnement

Référence complète de toutes les variables d'environnement utilisées dans LibreStock Inventory.

## Module API

Emplacement : `modules/api/.env`

### Base de données

| Variable | Requis | Description | Exemple |
|----------|--------|-------------|---------|
| `DATABASE_URL` | Oui* | Chaîne de connexion PostgreSQL complète | `postgresql://user:pass@localhost:5432/librestock` |
| `PGHOST` | Oui* | Hôte PostgreSQL | `localhost` |
| `PGPORT` | Oui* | Port PostgreSQL | `5432` |
| `PGUSER` | Oui* | Utilisateur PostgreSQL | `postgres` |
| `PGPASSWORD` | Oui* | Mot de passe PostgreSQL | `secret` |
| `PGDATABASE` | Oui* | Nom de la base PostgreSQL | `librestock_inventory` |

*Soit `DATABASE_URL` soit les variables `PG*` individuelles sont requises.

### Authentification

| Variable | Requis | Description | Exemple |
|----------|--------|-------------|---------|
| `CLERK_SECRET_KEY` | Oui | Clé API backend Clerk | `sk_test_xxx...` |

### Serveur

| Variable | Requis | Défaut | Description |
|----------|--------|--------|-------------|
| `PORT` | Non | `8080` | Port du serveur API |
| `NODE_ENV` | Non | `development` | Mode d'environnement |

### Exemple `.env`

```bash
# Base de données
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/librestock_inventory

# Authentification
CLERK_SECRET_KEY=sk_test_xxxxxxxxxxxx

# Serveur
PORT=8080
NODE_ENV=development
```

## Module Web

Emplacement : `modules/web/.env.local`

### API

| Variable | Requis | Description | Exemple |
|----------|--------|-------------|---------|
| `VITE_API_BASE_URL` | Oui | URL de l'API backend | `http://localhost:8080` |

### Authentification

| Variable | Requis | Description | Exemple |
|----------|--------|-------------|---------|
| `VITE_CLERK_PUBLISHABLE_KEY` | Oui | Clé API frontend Clerk | `pk_test_xxx...` |

### Exemple `.env.local`

```bash
# API
VITE_API_BASE_URL=http://localhost:8080

# Authentification
VITE_CLERK_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxx
```

## Secrets CI/CD

Secrets GitHub Actions requis pour la CI/CD :

| Secret | Description |
|--------|-------------|
| `CLERK_SECRET_KEY` | Clé API Clerk pour les tests CI |
| `AWS_DOCS_ROLE_ARN` | Rôle IAM pour le déploiement docs |
| `DOCS_S3_BUCKET` | Bucket S3 pour la documentation |
| `DOCS_CLOUDFRONT_DISTRIBUTION_ID` | ID de distribution CloudFront |

## Considérations de production

### Sécurité

- Ne jamais committer les fichiers `.env`
- Utiliser la gestion de secrets en production
- Faire une rotation des clés régulièrement

### Clerk

- Utiliser les clés de production en environnement de production
- Configurer les origines autorisées dans le dashboard Clerk

### Base de données

- Utiliser le connection pooling en production
- Activer SSL pour les connexions à la base de données
