import React from 'react';
import BottomNavigation from '@material-ui/core/BottomNavigation';
import BottomNavigationAction from '@material-ui/core/BottomNavigationAction';
import RestoreIcon from '@material-ui/core/SvgIcon/SvgIcon';
import {
  Switch, Route, Link,
} from 'react-router-dom';

import Profile from './profile';
import Home from './home';

const ProtectedApp = () => {
  const [value, setValue] = React.useState(0);
  return (
    <Switch>
      <Route path="/profil">
        <Profile />
      </Route>
      <Route path="/">
        <Home />
      </Route>
      <BottomNavigation
        value={value}
        onChange={(event, newValue) => {
          setValue(newValue);
        }}
        showLabels
      >
        <BottomNavigationAction
          component={Link}
          to="/"
          label="Accueil"
          icon={<RestoreIcon />}
        />
        <BottomNavigationAction
          component={Link}
          to="/profil"
          label="Profile"
          icon={<RestoreIcon />}
        />
        <BottomNavigationAction
          component={Link}
          to="/logout"
          label="Déconnexion"
          icon={<RestoreIcon />}
        />
      </BottomNavigation>
    </Switch>
  );
};

export default ProtectedApp;
