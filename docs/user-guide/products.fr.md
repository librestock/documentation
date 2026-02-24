# Gestion des Produits

Les produits sont au cœur du système LibreStock Inventory. Chaque produit représente un article dans votre inventaire d'approvisionnement de yacht.

## Affichage des Produits

Accédez à la section **Produits** depuis la barre latérale pour voir tous les produits.

<!-- ![Liste des Produits](../assets/screenshots/products/product-list.png) -->

La liste des produits affiche :

- **SKU** - Identifiant unique du produit
- **Nom** - Nom du produit
- **Catégorie** - Catégorie du produit
- **Prix** - Prix de vente standard
- **Statut** - Actif ou inactif

!!! tip "Filtrage des Produits"
    Utilisez la barre latérale des catégories pour filtrer les produits par catégorie. Cliquez sur une catégorie pour afficher uniquement les produits de cette catégorie et de ses sous-catégories.

## Création d'un Produit

1. Cliquez sur le bouton **Créer un Produit**
2. Remplissez les champs obligatoires :
   - **SKU** - Identifiant unique (peut être scanné via code QR)
   - **Nom** - Nom du produit
   - **Catégorie** - Sélectionnez dans l'arborescence des catégories

<!-- ![Formulaire Produit](../assets/screenshots/products/product-form.png) -->

### Champs du Produit

| Champ | Requis | Description |
|-------|--------|-------------|
| SKU | Oui | Unité de gestion de stock unique (max 50 car.) |
| Nom | Oui | Nom d'affichage du produit (max 200 car.) |
| Catégorie | Oui | Catégorie du produit |
| Description | Non | Description détaillée |
| Volume (ml) | Non | Volume en millilitres |
| Poids (kg) | Non | Poids en kilogrammes |
| Dimensions (cm) | Non | Dimensions, ex. : "10x10x5" |
| Coût Standard | Non | Coût d'achat |
| Prix Standard | Non | Prix de vente |
| Pourcentage de Marge | Non | Pourcentage de majoration |
| Point de Réapprovisionnement | Non | Seuil de stock bas (par défaut 0) |
| Fournisseur Principal | Non | Lien vers une fiche fournisseur |
| SKU Fournisseur | Non | SKU utilisé par le fournisseur |
| Code-barres | Non | Valeur du code-barres, ex. : "0641628607549" |
| Unité | Non | Unité de mesure, ex. : "unités" |
| Est Actif | Non | Disponibilité du produit (par défaut vrai) |
| Est Périssable | Non | Suivi de l'expiration (par défaut faux) |
| Notes | Non | Notes supplémentaires |

### Utilisation du Scanner QR

Cliquez sur l'icône de code QR à côté du champ SKU pour scanner un code-barres :

<!-- ![Scanner QR](../assets/screenshots/products/qr-scanner.png) -->

1. Autorisez l'accès à la caméra lorsque demandé
2. Pointez la caméra vers le code-barres
3. Le SKU sera automatiquement rempli

## Modification des Produits

1. Cliquez sur une ligne de produit pour ouvrir le formulaire de modification
2. Modifiez les champs selon vos besoins
3. Cliquez sur **Enregistrer** pour appliquer les modifications

!!! warning "Modifications de SKU"
    La modification du SKU d'un produit peut affecter les commandes et les enregistrements d'inventaire existants. Soyez prudent lors de la modification des SKUs.

## Opérations en Masse

Sélectionnez plusieurs produits à l'aide des cases à cocher pour effectuer des actions en masse :

- **Mise à Jour du Statut en Masse** - Activer ou désactiver plusieurs produits
- **Suppression en Masse** - Supprimer temporairement plusieurs produits
- **Restauration en Masse** - Restaurer des produits supprimés

### Exécution des Actions en Masse

1. Sélectionnez les produits à l'aide des cases à cocher
2. Cliquez sur le bouton d'action dans la barre d'outils
3. Confirmez l'action
4. Consultez le résumé des résultats

### Import CSV en Masse

Vous pouvez importer plusieurs produits à la fois en utilisant un fichier CSV :

1. Cliquez sur le bouton **Importer** dans la barre d'outils
2. Téléchargez le modèle CSV pour voir le format attendu
3. Remplissez les données produit dans le fichier CSV
4. Téléversez le fichier CSV complété
5. Vérifiez l'aperçu de l'import et confirmez

!!! tip "Conseils pour l'Import CSV"
    - Assurez-vous que les SKUs sont uniques et n'existent pas déjà dans le système
    - Les noms de catégories doivent correspondre exactement aux catégories existantes
    - Laissez les champs optionnels vides si non applicables

## Suppression et Restauration

Les produits sont supprimés temporairement par défaut, ce qui signifie qu'ils peuvent être restaurés :

1. Supprimez un produit en utilisant le bouton de suppression
2. Affichez les produits supprimés en basculant le filtre
3. Cliquez sur **Restaurer** pour récupérer un produit supprimé

!!! info "Suppression Définitive"
    La suppression définitive d'un produit le retire entièrement de la base de données. Cette action est irréversible.

## Images des Produits

Téléchargez des images pour aider à identifier les produits :

1. Cliquez sur la zone de téléchargement d'image
2. Sélectionnez un fichier image
3. L'image sera téléchargée et affichée

Formats supportés : PNG, JPG, WebP
