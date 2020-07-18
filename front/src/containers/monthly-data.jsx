import React, { useState, useCallback, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import IconButton from '@material-ui/core/IconButton';
import ArrowBackIosIcon from '@material-ui/icons/ArrowBackIos';
import ArrowForwardIosIcon from '@material-ui/icons/ArrowForwardIos';
import Typography from '@material-ui/core/Typography';
import Container from '@material-ui/core/Container';
import {
  addMonths, subMonths, isSameMonth,
} from 'date-fns';
import Chart from 'react-apexcharts';

import { format } from '../utils/date';
import { initType, requestType, monthlyDataType } from '../types';
import * as duck from '../ducks/wind-farm';
import Loader from '../components/loader';
import { minWidth } from '../styles/mixins';

const StyledContainer = styled(Container)`
  margin-top: 1rem;
  text-align: center;
`;

const DataContainer = styled.div`
  display: flex;
  flex-direction: column;
  ${minWidth.md`
    flex-direction: row;
  `}
`;

const ChartContainer = styled.div`
  flex: 1;
`;

const Production = styled.div`
  padding: 1rem;
`;

const ProductionLine = styled.div`
  display: flex;
  justify-content: space-between;
`;

const Title = styled(Typography)`
  margin: 1rem 0;
`;

const Header = styled.div`
  display: flex;
  justify-content: space-between
`;

const MonthlyData = ({ init, monthlyData, getMonthlyData }) => {
  const [month, setMonth] = useState(new Date());

  const onPrevious = useCallback(() => setMonth(subMonths(month, 1)), [month]);
  const onNext = useCallback(() => setMonth(addMonths(month, 1)), [month]);

  useEffect(() => {
    if (init.success) {
      getMonthlyData(month);
    }
  }, [init.success, getMonthlyData, month]);

  if (!init.success) return null;

  const lastMonth = isSameMonth(month, init.value.maxDate);
  const firstMonth = isSameMonth(month, init.value.minDate);

  return (
    <StyledContainer disableGutters>
      <Header>
        <IconButton onClick={onPrevious} disabled={firstMonth}><ArrowBackIosIcon /></IconButton>
        <Typography variant="h4">{format(month, 'MMMM')}</Typography>
        <IconButton onClick={onNext} disabled={lastMonth}><ArrowForwardIosIcon /></IconButton>
      </Header>
      {monthlyData.onGoing && (<Loader />)}
      {monthlyData.errors.length > 0 && (
        <Title variant="h4">Erreur de connexion au parc</Title>
      )}
      {monthlyData.success && (
        <DataContainer>
          <ChartContainer>
            <Chart
              options={{
                stroke: {
                  width: [0, 2],
                  curve: 'smooth',
                },
                plotOptions: {
                  bar: {
                    horizontal: false,
                  },
                },
                dataLabels: {
                  enabled: false,
                },
                xaxis: {
                  categories: monthlyData.value.labels,
                },
                yaxis: {
                  max: init.value.turbinePower * init.value.turbineCount * 24,
                },
              }}
              series={[{
                name: 'Production',
                type: 'bar',
                data: monthlyData.value.values,
              }, {
                name: monthlyData.value.productibles[0].name,
                type: 'line',
                data: monthlyData.value.goals,
              }]}
              type="line"
            />
          </ChartContainer>
          <Production>
            <ProductionLine>
              <Title variant="h5">Production&nbsp;</Title>
              <Title variant="h5">{`${Math.round(monthlyData.value.production / 1000)}\u00a0MWh`}</Title>
            </ProductionLine>
            {monthlyData.value.productibles.map((productible) => (
              <ProductionLine key={productible.name}>
                <Title variant="h5">{`${productible.name}\u00a0`}</Title>
                <Title variant="h5">
                  {`${Math.round((productible.value * monthlyData.value.ratio) / 1000)}\u00a0MWh`}
                </Title>
              </ProductionLine>
            ))}
          </Production>
        </DataContainer>
      )}
    </StyledContainer>
  );
};

MonthlyData.propTypes = {
  init: requestType(initType).isRequired,
  monthlyData: requestType(monthlyDataType).isRequired,
  getMonthlyData: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  init: state.windFarm.init,
  monthlyData: state.windFarm.monthlyData,
});

const mapDispatchToProps = {
  getMonthlyData: duck.getMonthlyData,
};

export default connect(mapStateToProps, mapDispatchToProps)(MonthlyData);
