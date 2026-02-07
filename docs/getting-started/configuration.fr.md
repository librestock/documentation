# Configuration

Ce guide couvre toutes les options de configuration pour LibreStock Inventory.

## Variables d'Environnement

### Backend API

Situé dans `modules/api/.env` :

| Variable | Requis | Description |
|----------|--------|-------------|
| `DATABASE_URL` | Oui | Chaîne de connexion PostgreSQL |
| `CLERK_SECRET_KEY` | Oui | Clé secrète Clerk pour l'authentification |
| `PORT` | Non | Port API (défaut: 8080) |
| `NODE_ENV` | Non | Mode d'environnement (development/production) |

**Exemple :**

```bash
DATABASE_URL=postgresql://user@localhost:5432/librestock_inventory
CLERK_SECRET_KEY=sk_test_...
PORT=8080
NODE_ENV=development
```

### Frontend Web

Situé dans `modules/web/.env.local` :

| Variable | Requis | Description |
|----------|--------|-------------|
| `VITE_API_BASE_URL` | Oui | URL de l'API backend |
| `VITE_CLERK_PUBLISHABLE_KEY` | Oui | Clé publique Clerk |
| `CLERK_SECRET_KEY` | Oui | Clé secrète Clerk |

**Exemple :**

```bash
VITE_API_BASE_URL=http://localhost:8080/api/v1
VITE_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
```

## Authentification Clerk

1. Créez une application Clerk sur https://clerk.com
2. Copiez vos clés API depuis le tableau de bord Clerk
3. Ajoutez-les à vos fichiers d'environnement

## Configuration de la Base de Données

### Utilisation de devenv (Recommandé)

La base de données est automatiquement configurée avec devenv :

- Nom de la base: `librestock_inventory`
- Hôte: `127.0.0.1`
- Port: `5432`

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
