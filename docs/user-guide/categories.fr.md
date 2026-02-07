# Gestion des Catégories

Les catégories aident à organiser vos produits dans une structure hiérarchique pour une navigation et un filtrage faciles.

## Hiérarchie des Catégories

Les catégories peuvent être imbriquées pour créer une structure arborescente :

```
Fournitures de Cuisine
├── Alimentation & Boissons
│   ├── Produits Frais
│   └── Produits Secs
├── Ustensiles de Cuisine
└── Couverts

Salle des Machines
├── Pièces Détachées
├── Lubrifiants
└── Outils
```

## Affichage des Catégories

L'arborescence des catégories est affichée dans la barre latérale lors de la consultation des produits. Cliquez sur une catégorie pour :

- Voir les produits de cette catégorie
- Voir les produits de toutes les sous-catégories
- Développer/réduire les catégories enfants

## Création d'une Catégorie

1. Accédez aux **Catégories** ou cliquez sur **Gérer les Catégories**
2. Cliquez sur **Créer une Catégorie**
3. Remplissez les champs :
   - **Nom** - Nom de la catégorie (requis)
   - **Description** - Description optionnelle
   - **Catégorie Parente** - Sélectionnez pour créer une sous-catégorie
4. Cliquez sur **Enregistrer**

!!! tip "Noms des Catégories"
    Utilisez des noms clairs et descriptifs. Les noms de catégories doivent être uniques au sein du même niveau parent.

## Modification des Catégories

1. Cliquez sur le bouton de modification d'une catégorie
2. Modifiez le nom, la description ou le parent
3. Cliquez sur **Enregistrer**

!!! warning "Changement de Parents"
    Déplacer une catégorie vers un nouveau parent déplacera également toutes ses sous-catégories. Le système empêche les références circulaires (une catégorie ne peut pas être son propre ancêtre).

## Suppression des Catégories

Lorsque vous supprimez une catégorie :

- Les produits de cette catégorie ne sont **pas** supprimés
- Les produits sont déplacés vers la catégorie parente (ou deviennent non catégorisés)
- Les sous-catégories deviennent enfants du parent

!!! danger "Suppression de Catégorie"
    La suppression d'une catégorie ne peut pas être annulée. Envisagez de déplacer les produits d'abord si nécessaire.

## Bonnes Pratiques

### Organisation des Catégories

1. **Gardez-le peu profond** - Visez 2-3 niveaux d'imbrication
2. **Soyez cohérent** - Utilisez des modèles de nommage similaires
3. **Planifiez à l'avance** - Considérez la croissance future

### Exemple de Structure

Pour un inventaire d'approvisionnement de yacht :

- **Cuisine** - Fournitures de cuisine et de table
- **Entretien** - Linge, produits de nettoyage
- **Sécurité** - Équipements de sécurité, premiers secours
- **Salle des Machines** - Fournitures techniques
- **Commodités Invités** - Articles de toilette, articles de luxe
- **Pont** - Équipements extérieurs
