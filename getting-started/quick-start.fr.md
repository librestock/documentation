# Démarrage Rapide

Ce guide vous accompagnera dans la création de vos premiers produits dans LibreStock Inventory.

## 1. Connexion

Accédez à http://localhost:3000 et connectez-vous avec votre compte Clerk.

## 2. Données d'Exemple (Optionnel)

Pour remplir la base de données avec des données d'exemple pour les tests :

```bash
cd modules/api
pnpm seed
```

Ceci crée :

- 10 catégories racines avec 3 sous-catégories chacune
- 20 fournisseurs d'exemple
- 100 produits d'exemple

## 3. Créer une Catégorie

1. Accédez à **Produits** dans la barre latérale
2. Cliquez sur **Gérer les Catégories**
3. Cliquez sur **Créer une Catégorie**
4. Entrez un nom (ex: "Fournitures de Cuisine")
5. Sélectionnez éventuellement une catégorie parente
6. Cliquez sur **Enregistrer**

## 4. Créer un Produit

1. Accédez à **Produits**
2. Cliquez sur **Créer un Produit**
3. Remplissez les champs obligatoires :
   - **SKU** - Entrez manuellement ou scannez un code-barres
   - **Nom** - Nom du produit
   - **Catégorie** - Sélectionnez dans l'arborescence
   - **Point de Réapprovisionnement** - Niveau de stock minimum
4. Cliquez sur **Enregistrer**

## 5. Voir les Journaux d'Audit

Toutes les modifications sont suivies automatiquement :

1. Accédez aux **Journaux d'Audit**
2. Consultez l'historique de toutes les modifications
3. Filtrez par type d'entité, utilisateur ou date

## Prochaines Étapes

- [Produits](../user-guide/products.md) - En savoir plus sur la gestion des produits
- [Catégories](../user-guide/categories.md) - Organiser votre inventaire
- [Configuration](configuration.md) - Personnaliser votre installation
