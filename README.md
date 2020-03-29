## Sources

- https://evilmartians.com/chronicles/graphql-on-rails-1-from-zero-to-the-first-query

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

- Tester les sagas
- Gérer le login et les routes privées côté react avec : https://reacttraining.com/react-router/web/example/auth-workflow
- Créer un point d'api pour l'authentification
- Vérifier que l'on peut appeler ensuite une api authentifiée
