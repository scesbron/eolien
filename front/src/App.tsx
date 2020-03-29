import React from 'react';
import './App.css';
import { Switch, BrowserRouter as Router } from 'react-router-dom';
import PrivateRoute from './routes/private-route';
import Home from './containers/home';

function App() {
  return (
    <Router>
      <Switch>
        <PrivateRoute path="/">
          <Home />
        </PrivateRoute>
      </Switch>
    </Router>
  );
}

export default App;
