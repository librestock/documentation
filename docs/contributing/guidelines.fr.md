# Directives de contribution

Ce document décrit les directives pour contribuer à LibreStock Inventory.

## Workflow de développement

### 1. Fork et clone

```bash
# Fork le repository sur GitHub, puis :
git clone https://github.com/VOTRE-NOM/meta.git
cd meta
```

### 2. Initialiser le workspace

```bash
# Installer les dépendances et configurer tous les dépôts
./meta/scripts/bootstrap
```

### 3. Créer une branche

```bash
git checkout -b feature/nom-de-votre-fonctionnalite
# ou
git checkout -b fix/description-du-probleme
```

### 4. Faire des modifications

- Suivez le [guide de style de code](../development/code-style.md)
- Écrivez des tests pour les nouvelles fonctionnalités
- Mettez à jour la documentation si nécessaire

### 5. Tester vos modifications

```bash
# Exécuter le linting backend
pnpm --filter @librestock/api lint

# Exécuter le linting frontend
pnpm --filter @librestock/web lint

# Exécuter les tests backend
pnpm --filter @librestock/api test

# Exécuter les tests E2E frontend
pnpm --filter @librestock/web test:e2e

# Build backend pour vérifier les erreurs de type
pnpm --filter @librestock/api build

# Build frontend pour vérifier les erreurs de type
pnpm --filter @librestock/web build
```

### 6. Committer vos modifications

Utilisez des messages de commit clairs et descriptifs :

```bash
git commit -m "feat: ajouter la fonctionnalité de recherche de produits"
git commit -m "fix: résoudre l'erreur de suppression de catégorie"
git commit -m "docs: mettre à jour le guide de développement API"
```

Suivez le format [Conventional Commits](https://www.conventionalcommits.org/) :

- `feat:` - Nouvelle fonctionnalité
- `fix:` - Correction de bug
- `docs:` - Modifications de documentation
- `style:` - Modifications de style de code (formatage, etc.)
- `refactor:` - Refactoring de code
- `test:` - Ajout ou mise à jour de tests
- `chore:` - Tâches de maintenance

### 7. Push et créer une PR

```bash
git push origin feature/nom-de-votre-fonctionnalite
```

Puis créez une pull request sur GitHub.

## Standards de code

### TypeScript

- Utiliser TypeScript strict
- Fournir des types pour tous les paramètres de fonction et valeurs de retour
- Éviter le type `any`

### Développement API

- Suivre le [guide de développement API](../development/api-development.md)
- Ajouter des décorateurs Swagger pour les nouveaux endpoints
- Inclure des décorateurs de validation sur les DTOs

### Développement Frontend

- Suivre le [guide de développement frontend](../development/frontend-development.md)
- Préférer les composants serveur quand c'est possible
- Utiliser les hooks API générés

### Tests

- Écrire des tests unitaires pour les nouvelles fonctionnalités
- Suivre le [guide de tests](../development/testing.md)
- Viser une couverture de tests significative

## Documentation

Lors de vos contributions :

- Mettez à jour la documentation pertinente
- Ajoutez des commentaires JSDoc pour les APIs publiques
- Incluez des exemples pour les fonctionnalités complexes

## Processus de review

1. **Vérifications automatiques** - La CI doit passer
2. **Code review** - Au moins une approbation requise
3. **Review de documentation** - Pour les changements significatifs
4. **Merge** - Squash and merge vers main

## Obtenir de l'aide

- Consultez les issues et la documentation existantes
- Posez des questions dans votre PR
- Contactez les mainteneurs
