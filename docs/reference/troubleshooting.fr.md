# Dépannage

Solutions aux problèmes courants lors du travail avec LibreStock Inventory.

## Environnement de développement

### Devenv ne démarre pas

**Symptôme :** `devenv up` échoue ou se bloque

**Solutions :**

1. Vérifier l'installation de Nix :
   ```bash
   nix --version
   ```

2. Mettre à jour devenv :
   ```bash
   nix-env -iA devenv -f https://github.com/NixOS/nixpkgs/tarball/nixos-unstable
   ```

3. Vider le cache devenv :
   ```bash
   rm -rf .devenv
   devenv up
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
   node --version  # Doit être 22+
   ```

## Problèmes de base de données

### Impossible de se connecter à PostgreSQL

**Symptôme :** Erreurs de connexion refusée

**Solutions :**

1. Vérifier si PostgreSQL est en cours d'exécution :
   ```bash
   pg_isready -h localhost -p 5432
   ```

2. Avec devenv, s'assurer qu'il est démarré :
   ```bash
   devenv up
   ```

3. Vérifier les variables d'environnement dans `.env`

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

## Problèmes API

### Erreurs d'authentification Clerk

**Symptôme :** Erreurs 401 Unauthorized

**Solutions :**

1. Vérifier `CLERK_SECRET_KEY` dans `modules/api/.env`
2. Vérifier que le token est envoyé :
   ```bash
   # La requête doit inclure :
   # Authorization: Bearer <token>
   ```
3. Vérifier la configuration du dashboard Clerk

### Échec du build des types partagés

**Symptôme :** Le build de `@librestock/types` échoue

**Solutions :**

1. Build l'API d'abord :
   ```bash
   pnpm --filter @librestock/api build
   ```

2. Vérifier les erreurs TypeScript :
   ```bash
   pnpm --filter @librestock/api build
   ```

## Problèmes Frontend

### Erreurs de types du client API

**Symptôme :** Erreurs TypeScript dans les hooks écrits à la main ou les types partagés

**Solutions :**

1. Rebuild des types partagés après les changements API :
   ```bash
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

1. Vérifier que les fichiers de locale existent dans `modules/web/src/locales/`
2. Vérifier la configuration i18n
3. Vérifier le préfixe de langue dans l'URL

## Problèmes de build

### Erreurs TypeScript

**Symptôme :** Le build échoue avec des erreurs de type

**Solutions :**

```bash
# Vérifier un module spécifique
pnpm --filter @librestock/api build
pnpm --filter @librestock/web build

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

1. Consultez les [issues existantes](https://github.com/your-org/librestock/issues)
2. Recherchez les messages d'erreur en ligne
3. Ouvrez une nouvelle issue avec :
    - Message d'erreur
    - Étapes pour reproduire
    - Détails de l'environnement
