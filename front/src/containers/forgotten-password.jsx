import React, { useCallback, useEffect, useState } from 'react';
import { Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/core/styles';
import { TextField } from 'mui-rff';
import { Form } from 'react-final-form';
import { Alert } from '@material-ui/lab';
import Typography from '@material-ui/core/Typography';
import { connect } from 'react-redux';
import { Link as RouterLink, useHistory } from 'react-router-dom';
import PropTypes from 'prop-types';
import Link from '@material-ui/core/Link';
import { green } from '@material-ui/core/colors';

import * as duck from '../ducks/user';
import logo from '../assets/images/hyrome.png';
import { LOGIN } from '../constants/routes';

const useStyles = makeStyles({
  container: {
    display: 'flex',
    justifyContent: 'center',
  },
  logo: {
    width: '100%',
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
  buttonSuccess: {
    marginTop: '1rem',
    backgroundColor: green[500],
    '&:hover': {
      backgroundColor: green[700],
    },
  },
  intro: {
    textAlign: 'center',
    marginTop: '1rem',
  },
  link: {
    textAlign: 'center',
    marginTop: '1rem',
  },
});

const ForgottenPassword = ({
  submitting, submitted, errors, forgottenPassword, setErrors,
}) => {
  const classes = useStyles();
  const history = useHistory();
  const [success, setSuccess] = useState(false);
  const buttonClass = success ? classes.buttonSuccess : classes.button;

  useEffect(() => { setErrors(); }, [setErrors]);
  useEffect(() => {
    if (submitted) {
      setSuccess(true);
      setTimeout(() => history.push(LOGIN), 1000);
    }
  }, [history, submitted]);

  const onSubmit = useCallback((values) => {
    forgottenPassword(values.username);
  }, [forgottenPassword]);

  return (
    <div className={classes.container}>
      <Form onSubmit={onSubmit}>
        {({ handleSubmit }) => (
          <form onSubmit={handleSubmit} className={classes.form}>
            <img src={logo} alt="Logo" className={classes.logo} />
            <div className={classes.intro}>
              <Typography variant="h4">Mot de passe oublié</Typography>
              <Typography>
                Indiquez votre nom d&apos;utilisateur pour recevoir par email un lien pour
                réinitialiser votre mot de passe.
              </Typography>
            </div>
            {errors.length > 0 && (
              <Alert variant="filled" severity="error">
                {errors.join('\n')}
              </Alert>
            )}
            <TextField label="Nom d'utilisateur" name="username" required />
            <Button type="submit" variant="contained" color="primary" className={buttonClass} disabled={submitting}>
              {success ? 'Email de réinitialisation envoyé' : 'Envoyer'}
            </Button>
            <Link component={RouterLink} to={LOGIN} className={classes.link}>
              Connexion
            </Link>
          </form>
        )}
      </Form>
    </div>
  );
};

ForgottenPassword.propTypes = {
  submitting: PropTypes.bool.isRequired,
  submitted: PropTypes.bool.isRequired,
  errors: PropTypes.arrayOf(PropTypes.string).isRequired,
  forgottenPassword: PropTypes.func.isRequired,
  setErrors: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  submitting: state.user.forgottenPasswordAsking,
  submitted: state.user.forgottenPasswordAsked,
  errors: state.user.errors,
});

const mapDispatchToProps = {
  forgottenPassword: duck.forgottenPassword,
  setErrors: duck.setErrors,
};

export default connect(mapStateToProps, mapDispatchToProps)(ForgottenPassword);
