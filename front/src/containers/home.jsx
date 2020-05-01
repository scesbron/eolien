/* eslint-disable no-nested-ternary */
import React, { useCallback, useEffect } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import Typography from '@material-ui/core/Typography';
import Container from '@material-ui/core/Container';
import { makeStyles } from '@material-ui/core/styles';
import Chart from 'react-apexcharts';

import {
  initType, requestType, userType, windTurbineStatusType,
} from '../types';
import * as duck from '../ducks/wind-farm';
import Loader from '../components/loader';

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
  user, init, status, initialize, getStatus,
}) => {
  const classes = useStyles();

  const update = useCallback(() => {
    if (!init.onGoing && !init.errors.length && (!init.success || status.errors.length)) {
      initialize();
    } else if (init.success && !status.onGoing && !status.errors.length) {
      getStatus();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    init.onGoing, init.errors.length, init.success, status.errors.length, initialize, getStatus,
  ]);

  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(() => { update(); }, []);

  useEffect(() => {
    let interval;
    if (init.success) {
      interval = setInterval(update, 2000);
      update();
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [init.success, update]);

  return (
    <Container className={classes.container}>
      <Typography variant="h4" className={classes.title}>{`Bonjour ${user.firstname}`}</Typography>
      { init.onGoing ? (
        <Typography variant="h4" className={classes.title}>Connexion au parc</Typography>
      ) : (init.errors.length || status.errors.length) ? (
        <Typography variant="h4" className={classes.title}>Erreur de connexion au parc</Typography>
      ) : (status.onGoing && !status.value) ? (
        <Typography variant="h4" className={classes.title}>Chargement des données</Typography>
      ) : (
        <div className={classes.farm}>
          {(status.value || []).map((turbine) => (
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
                {`Vent : ${turbine.windSpeed ? turbine.windSpeed.toFixed(2) : '?'} m/s`}
              </Typography>

            </div>
          ))}
        </div>
      )}
      {(init.onGoing || (status.onGoing && !status.value)) && (<Loader />)}
    </Container>
  );
};

Home.propTypes = {
  user: userType.isRequired,
  init: requestType(initType).isRequired,
  status: requestType(PropTypes.arrayOf(windTurbineStatusType)).isRequired,
  initialize: PropTypes.func.isRequired,
  getStatus: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  user: state.user.current,
  init: state.windFarm.init,
  status: state.windFarm.status,
});

const mapDispatchToProps = {
  initialize: duck.initialize,
  getStatus: duck.getStatus,
};

export default connect(mapStateToProps, mapDispatchToProps)(Home);
