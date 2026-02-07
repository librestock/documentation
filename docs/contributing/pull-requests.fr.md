# Processus de Pull Request

Ce guide explique comment créer et gérer les pull requests pour LibreStock Inventory.

## Créer une Pull Request

### Prérequis

Avant de créer une PR :

1. **Les tests passent localement**
   ```bash
   pnpm test
   ```

2. **Le linting passe**
   ```bash
   pnpm lint
   ```

3. **Le build réussit**
   ```bash
   pnpm build
   ```

4. **La branche est à jour**
   ```bash
   git fetch origin
   git rebase origin/main
   ```

### Template de PR

Lors de la création d'une PR, incluez :

```markdown
## Résumé

Brève description des changements.

## Changements

- Ajout de la fonctionnalité X
- Correction du bug Y
- Mise à jour de la documentation Z

## Plan de test

- [ ] Tests unitaires ajoutés/mis à jour
- [ ] Tests manuels effectués
- [ ] Documentation mise à jour

## Captures d'écran (si applicable)

[Ajouter des captures pour les changements UI]
```

## Processus de review

### 1. Vérifications automatiques

Quand vous ouvrez une PR, les vérifications suivantes s'exécutent automatiquement :

- **Linting** - Validation du style de code
- **Vérification des types** - Compilation TypeScript
- **Tests** - Tests unitaires et d'intégration
- **Build** - Vérifier que tous les packages buildent

Toutes les vérifications doivent passer avant le merge.

### 2. Code Review

- Au moins une approbation est requise
- Les reviewers vérifieront :
    - Qualité et style du code
    - Couverture de tests
    - Mises à jour de documentation
    - Considérations de sécurité

### 3. Répondre aux retours

- Répondez à tous les commentaires
- Poussez des commits supplémentaires pour adresser les retours
- Demandez une nouvelle review après les changements

## Merge

Une fois approuvé :

1. **Squash and merge** - Stratégie de merge par défaut
2. **Supprimer la branche** - Nettoyer après le merge
3. **CI sur main** - Vérifier le merge

## Bonnes pratiques

### Garder les PRs petites

- Plus faciles à review
- Plus rapides à merger
- Moins de risque de conflits

### Écrire des descriptions claires

- Expliquer le "pourquoi", pas seulement le "quoi"
- Lier aux issues concernées
- Inclure du contexte pour les reviewers

### Répondre rapidement

- Adresser les retours rapidement
- Maintenir la conversation en mouvement
- Poser des questions si quelque chose n'est pas clair

### Mettre à jour la documentation

- Changements README si nécessaire
- Documentation API pour les nouveaux endpoints
- Guide utilisateur pour les nouvelles fonctionnalités

## Gérer les conflits de merge

Si des conflits surviennent :

```bash
# Mettre à jour votre branche
git fetch origin
git rebase origin/main

# Résoudre les conflits
# Éditer les fichiers en conflit
git add <fichiers-resolus>
git rebase --continue

# Force push (uniquement pour les branches de PR)
git push --force-with-lease
```

## Après le merge

- Supprimer votre branche de fonctionnalité
- Vérifier que la CI passe sur main
- Vérifier le déploiement (si applicable)
