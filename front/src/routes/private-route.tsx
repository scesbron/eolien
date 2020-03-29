import React from 'react';
import { Route, Redirect } from 'react-router-dom';

const isAuthenticated = () => false;

type Props = {
  children: React.ReactNode,
  path: string,
};

const PrivateRoute = ({ children, path }: Props) => (
  <Route
    path={path}
    render={({ location }) => (
      isAuthenticated() ? (
        children
      ) : (
        <Redirect to={{ pathname: '/login', state: { from: location } }} />
      )
    )}
  />
);

export default PrivateRoute;
