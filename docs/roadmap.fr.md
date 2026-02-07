# Feuille de route

Cette feuille de route présente les fonctionnalités et améliorations planifiées pour LibreStock Inventory. Les éléments sont suivis en tant que [GitHub Issues](https://github.com/maximilianpw/librestock-inventory/issues).

!!! info "Contribuer"
    Intéressé à contribuer ? Consultez nos [directives de contribution](contributing/guidelines.md) et choisissez une issue à traiter !

## En cours

### Fonctionnalités d'inventaire de base

| Issue | Description | Priorité |
|-------|-------------|----------|
| [#39](https://github.com/maximilianpw/librestock-inventory/issues/39) | Créer les endpoints CRUD pour les articles d'inventaire | Haute |
| [#43](https://github.com/maximilianpw/librestock-inventory/issues/43) | Construire l'interface frontend des articles d'inventaire | Haute |
| [#41](https://github.com/maximilianpw/librestock-inventory/issues/41) | Créer l'API des emplacements/zones de stockage | Haute |
| [#42](https://github.com/maximilianpw/librestock-inventory/issues/42) | Implémenter l'API de gestion des fournisseurs | Moyenne |

### Inventaire avancé

| Issue | Description | Priorité |
|-------|-------------|----------|
| [#47](https://github.com/maximilianpw/librestock-inventory/issues/47) | Implémenter le suivi des transactions/historique d'inventaire | Haute |
| [#48](https://github.com/maximilianpw/librestock-inventory/issues/48) | Ajouter les alertes de stock bas et notifications | Haute |
| [#54](https://github.com/maximilianpw/librestock-inventory/issues/54) | Ajouter les opérations en masse pour la gestion d'inventaire | Moyenne |
| [#65](https://github.com/maximilianpw/librestock-inventory/issues/65) | Ajouter le suivi des dates d'expiration pour les périssables | Moyenne |
| [#64](https://github.com/maximilianpw/librestock-inventory/issues/64) | Implémenter le système de commandes/réquisitions | Moyenne |

### Recherche & Analytique

| Issue | Description | Priorité |
|-------|-------------|----------|
| [#49](https://github.com/maximilianpw/librestock-inventory/issues/49) | Implémenter l'API de recherche et filtrage avancé | Haute |
| [#50](https://github.com/maximilianpw/librestock-inventory/issues/50) | Construire l'interface de recherche avancée avec filtres | Haute |
| [#52](https://github.com/maximilianpw/librestock-inventory/issues/52) | Créer un tableau de bord avec analytiques d'inventaire | Moyenne |
| [#53](https://github.com/maximilianpw/librestock-inventory/issues/53) | Implémenter les rapports d'inventaire et fonctions d'export | Moyenne |

### Expérience utilisateur

| Issue | Description | Priorité |
|-------|-------------|----------|
| [#51](https://github.com/maximilianpw/librestock-inventory/issues/51) | Ajouter le support de scan code-barres/QR | Moyenne |
| [#66](https://github.com/maximilianpw/librestock-inventory/issues/66) | Créer le guide de démarrage et données d'exemple | Moyenne |
| [#44](https://github.com/maximilianpw/librestock-inventory/issues/44) | Implémenter le contrôle d'accès basé sur les rôles (RBAC) | Haute |

### Infrastructure & Opérations

| Issue | Description | Priorité |
|-------|-------------|----------|
| [#59](https://github.com/maximilianpw/librestock-inventory/issues/59) | Configurer le déploiement production (Docker + hébergement) | Haute |
| [#60](https://github.com/maximilianpw/librestock-inventory/issues/60) | Ajouter l'infrastructure de logging et monitoring | Haute |
| [#61](https://github.com/maximilianpw/librestock-inventory/issues/61) | Mettre en place la stratégie de backup et récupération | Haute |

### Qualité & Tests

| Issue | Description | Priorité |
|-------|-------------|----------|
| [#55](https://github.com/maximilianpw/librestock-inventory/issues/55) | Ajouter les tests unitaires et d'intégration pour l'API | Haute |
| [#56](https://github.com/maximilianpw/librestock-inventory/issues/56) | Ajouter les tests E2E pour le frontend avec Playwright | Moyenne |
| [#62](https://github.com/maximilianpw/librestock-inventory/issues/62) | Créer une documentation complète | Moyenne |

## Terminé

Ces fonctionnalités ont été implémentées :

| Issue | Description | Statut |
|-------|-------------|--------|
| [#40](https://github.com/maximilianpw/librestock-inventory/issues/40) | Créer l'API de gestion des catégories | :white_check_mark: Fait |
| [#45](https://github.com/maximilianpw/librestock-inventory/issues/45) | Construire l'interface d'authentification avec Clerk | :white_check_mark: Fait |
| [#46](https://github.com/maximilianpw/librestock-inventory/issues/46) | Créer l'interface de gestion des catégories et emplacements | :white_check_mark: Fait |
| [#57](https://github.com/maximilianpw/librestock-inventory/issues/57) | Configurer les outils de qualité de code et linting | :white_check_mark: Fait |
| [#58](https://github.com/maximilianpw/librestock-inventory/issues/58) | Configurer le pipeline CI/CD avec GitHub Actions | :white_check_mark: Fait |
| [#63](https://github.com/maximilianpw/librestock-inventory/issues/63) | Ajouter les fonctionnalités PWA responsive mobile | :white_check_mark: Fait |

## Considérations futures

Fonctionnalités en considération pour les versions futures :

- **Support multi-yacht** - Gérer l'inventaire sur plusieurs navires
- **Intégration fournisseurs** - Commande directe auprès des fournisseurs
- **Prédictions IA** - Suggestions de réapprovisionnement automatiques
- **Applications mobiles natives** - Applications iOS et Android
- **Sync offline-first** - Capacité offline complète avec synchronisation

## Planification des versions

| Version | Focus | Cible |
|---------|-------|-------|
| 0.1.0 | CRUD de base, Auth, Catégories | T1 2025 |
| 0.2.0 | Articles d'inventaire, Emplacements, Fournisseurs | T1 2025 |
| 0.3.0 | Recherche, Filtres, Tableau de bord | T2 2025 |
| 0.4.0 | Transactions, Alertes, Rapports | T2 2025 |
| 1.0.0 | Prêt pour la production, Documentation complète | T3 2025 |

---

*Dernière mise à jour : Décembre 2024*
