# Feuille de route

Cette feuille de route présente les fonctionnalités et améliorations planifiées pour LibreStock Inventory. Les éléments sont suivis en tant que [GitHub Issues](https://github.com/librestock/meta/issues).

!!! info "Contribuer"
    Intéressé à contribuer ? Consultez nos [directives de contribution](contributing/guidelines.md) et choisissez une issue à traiter !

## En cours

### Recherche & Analytique

| Description | Priorité |
|-------------|----------|
| Implémenter l'API de recherche et filtrage avancé | Haute |
| Construire l'interface de recherche avancée avec filtres | Haute |
| Créer un tableau de bord avec analytiques d'inventaire | Moyenne |
| Implémenter les rapports d'inventaire et fonctions d'export | Moyenne |

### Inventaire avancé

| Description | Priorité |
|-------------|----------|
| Ajouter les alertes de stock bas et notifications | Haute |
| Ajouter les opérations en masse pour la gestion d'inventaire | Moyenne |

### Expérience utilisateur

| Description | Priorité |
|-------------|----------|
| Ajouter le support de scan code-barres/QR | Moyenne |
| Créer le guide de démarrage et données d'exemple | Moyenne |

### Infrastructure & Opérations

| Description | Priorité |
|-------------|----------|
| Ajouter l'infrastructure de logging et monitoring | Haute |
| Mettre en place la stratégie de backup et récupération | Haute |

## Terminé

Ces fonctionnalités ont été implémentées :

### Modules principaux

| Description | Statut |
|-------------|--------|
| CRUD Produits | :white_check_mark: Fait |
| CRUD Catégories | :white_check_mark: Fait |
| CRUD Emplacements | :white_check_mark: Fait |
| CRUD Zones | :white_check_mark: Fait |
| Gestion d'inventaire | :white_check_mark: Fait |
| Mouvements de stock | :white_check_mark: Fait |
| Gestion des commandes (DRAFT, CONFIRMED, SOURCING, PICKING, PACKED, SHIPPED, DELIVERED, CANCELLED, ON_HOLD) | :white_check_mark: Fait |
| Module clients | :white_check_mark: Fait |
| Module fournisseurs | :white_check_mark: Fait |
| Journalisation d'audit | :white_check_mark: Fait |
| Gestion des photos | :white_check_mark: Fait |

### Authentification & Autorisation

| Description | Statut |
|-------------|--------|
| Authentification Better Auth | :white_check_mark: Fait |
| Système de rôles/permissions (PermissionGuard + @RequirePermission) | :white_check_mark: Fait |
| Gestion des utilisateurs (admin) | :white_check_mark: Fait |

### Frontend & API

| Description | Statut |
|-------------|--------|
| API REST HATEOAS | :white_check_mark: Fait |
| Frontend TanStack Start (React 19) | :white_check_mark: Fait |
| Personnalisation/branding | :white_check_mark: Fait |
| i18n (anglais, français, allemand) | :white_check_mark: Fait |

### Infrastructure & Qualité

| Description | Statut |
|-------------|--------|
| Support Docker (docker-compose) | :white_check_mark: Fait |
| CI/CD (GitHub Actions par dépôt) | :white_check_mark: Fait |
| Tests E2E (Playwright) | :white_check_mark: Fait |
| Site de documentation (MkDocs, GitHub Pages) | :white_check_mark: Fait |
| Outils de qualité de code et linting | :white_check_mark: Fait |

## Considérations futures

Fonctionnalités en considération pour les versions futures :

- **PWA** - Application Web Progressive avec support hors ligne
- **Support multi-yacht** - Gérer l'inventaire sur plusieurs navires
- **Intégration fournisseurs** - Commande directe auprès des fournisseurs
- **Prédictions IA** - Suggestions de réapprovisionnement automatiques
- **Applications mobiles natives** - Applications iOS et Android
- **Sync offline-first** - Capacité offline complète avec synchronisation

## Dépôts

| Dépôt | Description | Lien |
|-------|-------------|------|
| meta | Orchestration du workspace et scripts | [GitHub](https://github.com/librestock/meta) |
| backend | Serveur API NestJS | [GitHub](https://github.com/librestock/backend) |
| frontend | Application web TanStack Start | [GitHub](https://github.com/librestock/frontend) |
| packages | Types partagés et utilitaires | [GitHub](https://github.com/librestock/packages) |
| documentation | Site de documentation MkDocs | [GitHub](https://github.com/librestock/documentation) |
| remote-desktop | Outils de bureau à distance | [GitHub](https://github.com/librestock/remote-desktop) |
| landing | Page d'accueil | [GitHub](https://github.com/librestock/landing) |

---

*Dernière mise à jour : Février 2026*
