/* eslint-disable no-nested-ternary */
import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import Typography from '@material-ui/core/Typography';
import Container from '@material-ui/core/Container';
import Chart from 'react-apexcharts';
import styled from 'styled-components';

import {
  initType,
  requestType, windTurbineStatusType,
} from '../types';
import * as duck from '../ducks/wind-farm';
import Loader from '../components/loader';

const Farm = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
`;

const Turbine = styled.div`
  width: 250px;
  display: flex;
  flex-direction: column;
  align-items: center;
`;

const ChartContainer = styled.div`
  width: 250px;
  height: 170px;
`;

const StyledContainer = styled(Container)`
  margin-top: 1rem;
  text-align: center;
`;

const Title = styled(Typography)`
  padding: 1rem 0;
`;

const RealTimeData = ({
  init, status, initialize, getStatus,
}) => {
  useEffect(() => {
    if (status.errors.length) {
      initialize();
    }
  }, [status.errors.length, initialize]);

  useEffect(() => {
    let interval;
    if (init.success) {
      getStatus();
      interval = setInterval(getStatus, 2000);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [init.success]);

  if (status.onGoing && !status.value) {
    return (
      <StyledContainer>
        <Title variant="h4">Chargement des données</Title>
        <Loader />
      </StyledContainer>
    );
  }

  if (status.errors.length) {
    return (
      <StyledContainer>
        <Title variant="h4">Erreur de connexion au parc</Title>
      </StyledContainer>
    );
  }

  return (
    <StyledContainer disableGutters>
      <Farm>
        {(status.value || []).map((turbine) => (
          <Turbine key={turbine.name}>
            <ChartContainer>
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
                          formatter: (val) => `${parseInt((val * init.value.turbinePower) / 100, 10)} kwh`,
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
                series={[Math.min(100, (turbine.instantPower / init.value.turbinePower) * 100)]}
                type="radialBar"
                width="250"
              />
            </ChartContainer>
            <Typography>
              {`Vent : ${turbine.windSpeed ? turbine.windSpeed.toFixed(2) : '?'} m/s`}
            </Typography>
          </Turbine>
        ))}
      </Farm>
    </StyledContainer>
  );
};

RealTimeData.propTypes = {
  init: requestType(initType).isRequired,
  status: requestType(PropTypes.arrayOf(windTurbineStatusType)).isRequired,
  initialize: PropTypes.func.isRequired,
  getStatus: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  init: state.windFarm.init,
  status: state.windFarm.status,
});

const mapDispatchToProps = {
  initialize: duck.initialize,
  getStatus: duck.getStatus,
};

export default connect(mapStateToProps, mapDispatchToProps)(RealTimeData);
