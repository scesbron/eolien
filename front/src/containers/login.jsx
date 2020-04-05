import React, { useCallback, useEffect } from 'react';
import { Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/core/styles';
import { TextField } from 'mui-rff';
import { Form } from 'react-final-form';
import { Alert } from '@material-ui/lab';
import { connect } from 'react-redux';
import { useHistory, useLocation } from 'react-router-dom';
import PropTypes from 'prop-types';

import * as duck from '../ducks/user';
import { User } from '../types';

const useStyles = makeStyles({
  container: {
    display: 'flex',
    justifyContent: 'center',
  },
  form: {
    maxWidth: '30rem',
    padding: '1rem',
    display: 'flex',
    flexDirection: 'column',
    flex: 1,
  },
  button: {
    marginTop: '1rem',
  },
});

const Login = ({
  user, loading, errors, login,
}) => {
  const classes = useStyles();
  const history = useHistory();
  const location = useLocation();

  useEffect(() => {
    if (user) {
      const { from } = location.state || { from: { pathname: '/' } };
      history.replace(from);
    }
  }, [user]);

  const onSubmit = useCallback((values) => {
    login(values.email, values.password);
  }, []);

  return (
    <div className={classes.container}>
      <Form
        onSubmit={onSubmit}
        render={({ handleSubmit }) => (
          <form onSubmit={handleSubmit} className={classes.form}>
            {errors.length > 0 && (
              <Alert variant="filled" severity="error">
                {errors.join('\n')}
              </Alert>
            )}
            <TextField label="Email" name="email" required />
            <TextField label="Mot de passe" name="password" required />
            <Button type="submit" variant="contained" color="primary" className={classes.button} disabled={loading}>
              Connexion
            </Button>
          </form>
        )}
      />
    </div>
  );
};

Login.propTypes = {
  user: User,
  loading: PropTypes.bool.isRequired,
  errors: PropTypes.arrayOf(PropTypes.string).isRequired,
  login: PropTypes.func.isRequired,
};

Login.defaultProps = {
  user: undefined,
};

const mapStateToProps = (state) => ({
  user: state.user.current,
  loading: state.user.loading,
  errors: state.user.errors,
});

const mapDispatchToProps = {
  login: duck.login,
};

export default connect(mapStateToProps, mapDispatchToProps)(Login);
