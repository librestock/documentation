# Gestion des Emplacements

Les emplacements représentent les lieux physiques où l'inventaire est stocké. Cela inclut les entrepôts, les locaux fournisseurs, les yachts clients et les articles en transit.

## Comprendre les Emplacements

Les emplacements sont catégorisés par type :

| Type | Description | Cas d'utilisation |
|------|-------------|-------------------|
| **WAREHOUSE** | Vos installations de stockage | Stockage principal de l'inventaire |
| **SUPPLIER** | Locaux de stockage des fournisseurs | Suivi du stock fournisseur |
| **CLIENT** | Yacht ou locaux du client | Articles livrés aux clients |
| **IN_TRANSIT** | Articles en cours de transport | Suivi des expéditions |

## Affichage des Emplacements

Accédez à la section **Emplacements** depuis la barre latérale pour voir tous les emplacements.

La liste des emplacements affiche :

- **Nom** - Identifiant de l'emplacement
- **Type** - Catégorie de l'emplacement
- **Adresse** - Adresse physique
- **Contact** - Personne de contact principale
- **Statut** - Actif ou inactif

!!! tip "Filtrage des Emplacements"
    Utilisez le filtre par type pour afficher uniquement les entrepôts, fournisseurs ou autres types d'emplacements.

## Création d'un Emplacement

1. Cliquez sur le bouton **Créer un Emplacement**
2. Remplissez les champs obligatoires :
   - **Nom** - Nom de l'emplacement (ex. : "Entrepôt Miami")
   - **Type** - Sélectionnez le type d'emplacement
   - **Adresse** - Adresse physique (optionnel)

### Champs de l'Emplacement

| Champ | Requis | Description |
|-------|--------|-------------|
| Nom | Oui | Nom d'affichage de l'emplacement |
| Type | Oui | WAREHOUSE, SUPPLIER, CLIENT ou IN_TRANSIT |
| Adresse | Non | Adresse physique |
| Personne de Contact | Non | Nom du contact principal |
| Téléphone | Non | Numéro de téléphone du contact |
| Est Actif | Non | Disponibilité de l'emplacement (par défaut vrai) |

## Modification des Emplacements

1. Cliquez sur une ligne d'emplacement pour ouvrir le formulaire de modification
2. Modifiez les champs selon vos besoins
3. Cliquez sur **Enregistrer** pour appliquer les modifications

!!! warning "Suppression des Emplacements"
    La suppression d'un emplacement **échouera** si d'autres entités le référencent (enregistrements d'inventaire, zones, etc.). Vous devez supprimer ou réassigner tous les enregistrements d'inventaire et zones associés avant de supprimer un emplacement.

## Hiérarchie des Emplacements

Les emplacements peuvent contenir des **Zones** pour un suivi plus granulaire du placement :

```
Entrepôt Miami (Emplacement)
├── Zone A (Zone)
│   ├── Étagère A1 (Zone)
│   └── Étagère A2 (Zone)
├── Zone B (Zone)
└── Stockage Froid (Zone)
```

Voir [Gestion des Zones](areas.md) pour les détails sur la création de zones au sein des emplacements.

## Bonnes Pratiques

1. **Utilisez des noms descriptifs** - Incluez la ville ou l'objectif (ex. : "Fournisseur Monaco - Linge")
2. **Gardez les coordonnées à jour** - Facilite les réapprovisionnements rapides
3. **Créez des zones pour les grands emplacements** - Suivez le placement exact au sein des entrepôts
4. **Utilisez IN_TRANSIT pour les expéditions** - Suivez les articles en déplacement entre emplacements
