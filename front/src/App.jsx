import React from 'react';
import {
  Switch, BrowserRouter as Router, Route,
} from 'react-router-dom';

import PrivateRoute from './routes/private-route';
import Login from './containers/login';
import ProtectedApp from './containers/protected-app';

function App() {
  return (
    <Router>
      <Switch>
        <Route path="/login">
          <Login />
        </Route>
        <PrivateRoute path="/">
          <ProtectedApp />
        </PrivateRoute>
      </Switch>
    </Router>
  );
}

export default App;
