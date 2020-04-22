/* eslint-disable no-nested-ternary */
import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import Typography from '@material-ui/core/Typography';
import Container from '@material-ui/core/Container';
import { makeStyles } from '@material-ui/core/styles';

import { User, WindTurbineStatusType } from '../types';
import * as duck from '../ducks/wind-farm';

const useStyles = makeStyles({
  container: {
    paddingBottom: '72px',
    textAlign: 'center',
  },
  title: {
    marginTop: '1rem',
    marginBottom: '1rem',
  },
});

const Home = ({
  user, initializing, initialized, errors, status, initialize, getStatus,
}) => {
  const classes = useStyles();
  useEffect(() => { initialize(); }, [initialize]);
  useEffect(() => {
    let interval;
    if (initialized) {
      interval = setInterval(getStatus, 2000);
      getStatus();
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [initialized, getStatus]);
  return (
    <Container className={classes.container}>
      <Typography variant="h4" className={classes.title}>{`Bonjour ${user.firstname}`}</Typography>
      { initializing ? (
        <Typography variant="h4" className={classes.title}>Connexion au parc</Typography>
      ) : errors.length > 0 ? (
        <Typography variant="h4" className={classes.title}>Erreur de connexion au parc</Typography>
      ) : !status ? (
        <Typography variant="h4" className={classes.title}>Chargement des données</Typography>
      ) : status.map((turbine) => (
        <>
          <Typography variant="h4" className={classes.title}>{turbine.name}</Typography>
          <Typography variant="h4" className={classes.title}>
            Vitesse du vent :
            {turbine.windSpeed}
          </Typography>
          <Typography variant="h4" className={classes.title}>
            Puissance instantanée :
            {turbine.instantPower}
          </Typography>
        </>
      ))}
    </Container>
  );
};

Home.propTypes = {
  user: User.isRequired,
  initializing: PropTypes.bool.isRequired,
  initialized: PropTypes.bool.isRequired,
  errors: PropTypes.arrayOf(PropTypes.string).isRequired,
  status: PropTypes.arrayOf(WindTurbineStatusType),
  initialize: PropTypes.func.isRequired,
  getStatus: PropTypes.func.isRequired,
};

Home.defaultProps = {
  status: undefined,
};

const mapStateToProps = (state) => ({
  user: state.user.current,
  initializing: state.windFarm.initializing,
  initialized: state.windFarm.initialized,
  status: state.windFarm.status,
  errors: state.windFarm.errors,
});

const mapDispatchToProps = {
  initialize: duck.initialize,
  getStatus: duck.getStatus,
};

export default connect(mapStateToProps, mapDispatchToProps)(Home);
