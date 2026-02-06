# Journaux d'Audit

Le journal d'audit suit toutes les modifications apportées au système, fournissant un historique complet pour la responsabilité et le dépannage.

## Consultation des Journaux d'Audit

Accédez aux **Journaux d'Audit** pour voir l'historique complet des modifications.

Chaque entrée de journal inclut :

- **Horodatage** - Quand la modification a eu lieu
- **Utilisateur** - Qui a effectué la modification
- **Action** - Type d'action (Créer, Modifier, Supprimer, Restaurer)
- **Type d'Entité** - Ce qui a été modifié (Produit, Catégorie, etc.)
- **ID de l'Entité** - L'élément spécifique modifié
- **Modifications** - Valeurs avant/après

## Filtrage des Journaux

Filtrez les journaux d'audit par :

- **Type d'Entité** - Produits, Catégories, Commandes, etc.
- **Action** - Créer, Modifier, Supprimer, Restaurer
- **Utilisateur** - Utilisateur spécifique
- **Période** - Plage de dates
- **ID de l'Entité** - Élément spécifique

## Comprendre les Modifications

Pour les actions de modification, le journal affiche :

```json
{
  "before": {
    "name": "Ancien Nom du Produit",
    "price": 100
  },
  "after": {
    "name": "Nouveau Nom du Produit",
    "price": 150
  }
}
```

## Types d'Actions

| Action | Description |
|--------|-------------|
| CREATE | Nouvel élément créé |
| UPDATE | Élément existant modifié |
| DELETE | Élément supprimé temporairement |
| RESTORE | Élément supprimé restauré |
| ADJUST_QUANTITY | Quantité d'inventaire modifiée |
| ADD_PHOTO | Photo ajoutée à l'élément |
| STATUS_CHANGE | Champ de statut modifié |

## Types d'Entités

| Entité | Description |
|--------|-------------|
| PRODUCT | Produits d'inventaire |
| CATEGORY | Catégories de produits |
| SUPPLIER | Enregistrements fournisseurs |
| ORDER | Commandes clients |
| ORDER_ITEM | Articles de commande |
| INVENTORY | Quantités en stock |
| LOCATION | Emplacements de stockage |
| STOCK_MOVEMENT | Transactions d'inventaire |
| PHOTO | Images de produits |

## Informations de Contexte

Chaque journal d'audit inclut le contexte :

- **Adresse IP** - Origine de la requête
- **User Agent** - Informations navigateur/client
- **ID Utilisateur** - Utilisateur authentifié

## Cas d'Utilisation

### Dépannage

1. Trouver quand un produit a été modifié pour la dernière fois
2. Voir qui a changé un prix
3. Suivre les ajustements d'inventaire

### Conformité

1. Démontrer le suivi des modifications
2. Fournir une piste d'audit pour les auditeurs
3. Répondre aux exigences réglementaires

### Récupération

1. Identifier les modifications accidentelles
2. Comprendre ce qui a été changé
3. Restaurer manuellement les valeurs précédentes si nécessaire
