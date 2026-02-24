# Dépannage

Solutions aux problèmes courants lors du travail avec LibreStock Inventory.

## Environnement de développement

### Le shell Nix ne démarre pas

**Symptôme :** `nix develop` échoue ou se bloque

**Solutions :**

1. Vérifier l'installation de Nix :
   ```bash
   nix --version
   ```

2. S'assurer que les flakes sont activés dans votre configuration Nix (`~/.config/nix/nix.conf`) :
   ```
   experimental-features = nix-command flakes
   ```

3. Essayer d'entrer dans le shell depuis le répertoire du dépôt spécifique :
   ```bash
   cd backend && nix develop
   ```

### Les services Docker ne démarrent pas

**Symptôme :** `docker compose -f meta/docker-compose.yml up -d` échoue

**Solutions :**

1. Vérifier que Docker est en cours d'exécution :
   ```bash
   docker info
   ```

2. Vérifier les conflits de ports :
   ```bash
   lsof -i :5432
   ```

3. Réinitialiser les conteneurs Docker :
   ```bash
   docker compose -f meta/docker-compose.yml down -v
   docker compose -f meta/docker-compose.yml up -d
   ```

### Port déjà utilisé

**Symptôme :** Erreur "Address already in use"

**Solutions :**

```bash
# Trouver le processus utilisant le port
lsof -i :8080  # ou :3000, :5432

# Tuer le processus
kill -9 <PID>
```

### Les dépendances ne s'installent pas

**Symptôme :** `pnpm install` échoue

**Solutions :**

1. Vider le cache pnpm :
   ```bash
   pnpm store prune
   rm -rf node_modules
   pnpm install
   ```

2. Vérifier la version de Node.js :
   ```bash
   node --version  # Doit être 20+
   ```

## Problèmes de base de données

### Impossible de se connecter à PostgreSQL

**Symptôme :** Erreurs de connexion refusée

**Solutions :**

1. Vérifier si PostgreSQL est en cours d'exécution :
   ```bash
   pg_isready -h localhost -p 5432
   ```

2. Démarrer PostgreSQL via Docker Compose :
   ```bash
   docker compose -f meta/docker-compose.yml up -d
   ```

3. Vérifier les variables d'environnement dans `backend/.env`

### Erreurs de migration

**Symptôme :** Erreurs TypeORM concernant le schéma

**Solutions :**

1. Synchroniser le schéma (développement uniquement) :
   ```bash
   # TypeORM synchronize est activé en dev
   # Redémarrer le serveur API
   ```

2. Vérifier que la base de données existe :
   ```bash
   psql -h localhost -U postgres -c '\l'
   ```

3. Exécuter les migrations en attente :
   ```bash
   pnpm --filter @librestock/api migration:run
   ```

## Problèmes API

### Erreurs d'authentification Better Auth

**Symptôme :** Erreurs 401 Unauthorized

**Solutions :**

1. Vérifier que `BETTER_AUTH_SECRET` est défini dans `backend/.env` (doit être 32+ octets aléatoires)
2. Vérifier que `BETTER_AUTH_URL` est correctement défini (ex : `http://localhost:8080`)
3. Vérifier que le token est envoyé :
   ```bash
   # La requête doit inclure :
   # Authorization: Bearer <token>
   ```
4. Essayer de régénérer le secret :
   ```bash
   openssl rand -base64 32
   ```
   Mettre à jour `BETTER_AUTH_SECRET` dans `backend/.env` et redémarrer le serveur.

### Échec du build des types partagés

**Symptôme :** Le build de `@librestock/types` échoue

**Solutions :**

1. Build l'API d'abord :
   ```bash
   pnpm --filter @librestock/api build
   ```

2. Vérifier les erreurs TypeScript :
   ```bash
   pnpm --filter @librestock/api type-check
   ```

## Problèmes Frontend

### Erreurs de types du client API

**Symptôme :** Erreurs TypeScript dans les hooks écrits à la main ou les types partagés

**Solutions :**

1. Rebuild des types partagés après les changements API :
   ```bash
   pnpm --filter @librestock/types barrels
   pnpm --filter @librestock/types build
   ```

### Erreurs d'hydratation

**Symptôme :** Avertissements de mismatch d'hydratation React

**Solutions :**

1. S'assurer que le rendu client/serveur correspond
2. Éviter le code navigateur au niveau module côté SSR
3. Reporter les APIs navigateur dans des effets ou guards

### Les traductions ne fonctionnent pas

**Symptôme :** Clés de traduction affichées au lieu du texte

**Solutions :**

1. Vérifier que les fichiers de locale existent dans `frontend/src/locales/`
2. Vérifier la configuration i18n
3. Vérifier le préfixe de langue dans l'URL

## Problèmes de build

### Erreurs TypeScript

**Symptôme :** Le build échoue avec des erreurs de type

**Solutions :**

```bash
# Vérifier un module spécifique
pnpm --filter @librestock/api type-check
pnpm --filter @librestock/web type-check
```

### Erreurs ESLint

**Symptôme :** La commande lint échoue

**Solutions :**

```bash
# Auto-corriger ce qui est possible
pnpm --filter @librestock/api lint --fix
pnpm --filter @librestock/web lint:fix
```

## Problèmes CI/CD

### GitHub Actions échoue

**Symptôme :** Les vérifications CI échouent

**Solutions :**

1. Exécuter les vérifications localement d'abord :
   ```bash
   pnpm lint && pnpm test && pnpm build
   ```

2. Vérifier que les secrets sont configurés dans GitHub

3. Vider le cache GitHub Actions si nécessaire

## Obtenir plus d'aide

Si vous êtes toujours bloqué :

1. Consultez les [issues existantes](https://github.com/librestock/documentation/issues)
2. Recherchez les messages d'erreur en ligne
3. Ouvrez une nouvelle issue avec :
    - Message d'erreur
    - Étapes pour reproduire
    - Détails de l'environnement
