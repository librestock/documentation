# Référence

Documentation de référence technique pour LibreStock Inventory.

## Contenu

- [Variables d'environnement](environment-variables.md) - Toutes les options de configuration
- [Commandes CLI](cli-commands.md) - Commandes disponibles en ligne de commande
- [Dépannage](troubleshooting.md) - Problèmes courants et solutions

## Liens rapides

### Documentation API

L'API est documentée via Swagger UI :

- **Local :** http://localhost:8080/api/docs
- **OpenAPI JSON :** http://localhost:8080/api/docs-json

### Types partagés

Les interfaces/enums DTO partagés vivent dans `packages/types` :

```bash
pnpm --filter @librestock/types build
```

Les types sont dans `packages/types/src/`.
