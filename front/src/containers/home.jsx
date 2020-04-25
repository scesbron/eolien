/* eslint-disable no-nested-ternary */
import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import Typography from '@material-ui/core/Typography';
import Container from '@material-ui/core/Container';
import { makeStyles } from '@material-ui/core/styles';
import Chart from 'react-apexcharts';

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
  farm: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  turbine: {
    width: '250px',
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  chart: {
    width: '250px',
    height: '170px',
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
      ) : (
        <div className={classes.farm}>
          {status.map((turbine) => (
            <div key={turbine.name} className={classes.turbine}>
              <div className={classes.chart}>
                <Chart
                  options={{
                    plotOptions: {
                      radialBar: {
                        startAngle: -135,
                        endAngle: 135,
                        hollow: {
                          margin: 0,
                          size: '70%',
                        },
                        dataLabels: {
                          name: {
                            show: true,
                            color: '#388e3c',
                          },
                          value: {
                            show: true,
                            color: '#81c784',
                            formatter: (val) => `${parseInt(val * 24, 10)} kwh`,
                          },
                        },
                      },
                    },
                    fill: {
                      colors: ['#388e3c'],
                    },
                    stroke: {
                      lineCap: 'round',
                    },
                    labels: [turbine.name],
                  }}
                  series={[turbine.instantPower / 24]}
                  type="radialBar"
                  width="250"
                />
              </div>
              <Typography>
                {`Vent : ${turbine.windSpeed.toFixed(2)} m/s`}
              </Typography>
            </div>
          ))}
        </div>
      )}
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
