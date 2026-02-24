# Système d'Inventaire LibreStock

Bienvenue dans la documentation LibreStock Inventory. Ce système aide à gérer l'inventaire d'approvisionnement des yachts avec des fonctionnalités de gestion des produits, de suivi des commandes et de journalisation des audits.

Construit avec NestJS (backend), TanStack Start avec React 19 (frontend), PostgreSQL, Better Auth et TypeORM.

## Liens Rapides

<div class="grid cards" markdown>

- :material-rocket-launch: **Démarrage**

    Commencez avec LibreStock Inventory en quelques minutes.

    [:octicons-arrow-right-24: Installation](getting-started/installation.md)

- :material-book-open-variant: **Guide Utilisateur**

    Apprenez à utiliser toutes les fonctionnalités de l'application.

    [:octicons-arrow-right-24: Guide Utilisateur](user-guide/index.md)

- :material-code-braces: **Développement**

    Configurez votre environnement de développement et contribuez.

    [:octicons-arrow-right-24: Développement](development/index.md)

- :material-map: **Feuille de Route**

    Découvrez ce qui est prévu pour les prochaines versions.

    [:octicons-arrow-right-24: Feuille de Route](roadmap.md)

</div>

## Fonctionnalités

- **Gestion des Produits** - Créez et organisez des produits avec SKUs, prix et catégories
- **Hiérarchie des Catégories** - Catégorisation multi-niveaux avec imbrication illimitée
- **Suivi des Emplacements** - Gérez les entrepôts, fournisseurs, clients et emplacements en transit
- **Gestion des Zones** - Définissez des zones, étagères et bacs au sein des emplacements
- **Contrôle d'Inventaire** - Suivez les quantités en stock à travers les emplacements avec suivi des lots et dates d'expiration
- **Mouvements de Stock** - Suivez et enregistrez les mouvements de stock entre emplacements
- **Traitement des Commandes** - Suivez les commandes d'approvisionnement des yachts tout au long du cycle complet (DRAFT, CONFIRMED, SOURCING, PICKING, PACKED, SHIPPED, DELIVERED, CANCELLED, ON_HOLD)
- **Module Clients** - Gérez les informations et relations clients
- **Module Fournisseurs** - Gérez les informations et relations fournisseurs
- **Piste d'Audit** - Historique complet des modifications avec suivi des utilisateurs
- **Authentification** - Système d'authentification Better Auth
- **Rôles & Permissions** - Contrôle d'accès basé sur les rôles avec PermissionGuard et @RequirePermission
- **Gestion des Utilisateurs** - Administration des utilisateurs
- **Gestion des Photos** - Gestion des photos de produits et d'inventaire
- **Personnalisation/Branding** - Options de personnalisation de la marque
- **Multi-langue** - Support anglais, français et allemand
- **API REST HATEOAS** - Conception d'API pilotée par hypermédia
- **Tests E2E** - Tests de bout en bout avec Playwright
- **Support Docker** - Docker Compose pour le déploiement conteneurisé
- **CI/CD** - Pipelines GitHub Actions par dépôt
- **Documentation** - Site MkDocs avec GitHub Pages
- **Scan QR** - Numérisation de codes-barres pour une recherche rapide des produits
