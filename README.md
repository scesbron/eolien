## Sources

- https://evilmartians.com/chronicles/graphql-on-rails-1-from-zero-to-the-first-query
- https://medium.com/@mazik.wyry/rails-5-api-jwt-setup-in-minutes-using-devise-71670fd4ed03

## Commands

### Create the project

```
rails new eolien -d=postgresql --skip-action-mailbox --skip-action-text --skip-spring --webpack=react -T --skip-turbolinks --api
```

### Front

```
yarn add react-router-dom react-redux redux redux-saga axios
```

## TODO

- Gérer le login et les routes privées côté react avec : https://reacttraining.com/react-router/web/example/auth-workflow
- Vérifier que l'on peut appeler ensuite une api authentifiée
- Supprimer les méthodes eolien? et seve? et voir comment réécrire ce qui en dépend
- Comment gérer l'authentification par token en react (dans private route on regarde s'il y a l'attribut et on appelle le serveur ?)

User.create(firstname: 'Sébastien', lastname: 'Cesbron', email:'seb@chezsoi.org', username: 'scesbron', password:'123456')

### EoLien

- legal_name : S.A. Eo-Lien - Soci&eacute;t&eacute; Anonyme au capital de 571 000 &euro; - RCS Angers 803 505 528
- address: 11 rue de Bel Air - 49750 Chanzeaux
- email: contact@eo-lien.fr
- legal_agent : Maxence Guérin
- phone : 06.13.16.17.86

### SEVE

- legal_name: S.A.S. SEVE - Société par Actions Simplifiée au capital de 429 000 € - RCS Angers 794 787 119
- address: La Confordière - 49120 La Tourlandry
- legal_agent: François Girard
- phone: 06.80.63.06.54
