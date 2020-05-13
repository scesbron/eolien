import React, { useState, useCallback, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { TextField } from '@material-ui/core';
import IconButton from '@material-ui/core/IconButton';
import ArrowBackIosIcon from '@material-ui/icons/ArrowBackIos';
import ArrowForwardIosIcon from '@material-ui/icons/ArrowForwardIos';
import Typography from '@material-ui/core/Typography';
import Container from '@material-ui/core/Container';
import {
  parse, isSameDay, isToday, subDays, addDays, isValid, isFuture, getMinutes,
} from 'date-fns';
import Chart from 'react-apexcharts';

import { format } from '../utils/date';
import { initType, requestType, dailyDataType } from '../types';
import * as duck from '../ducks/wind-farm';
import Loader from '../components/loader';

const StyledContainer = styled(Container)`
  margin-top: 1rem;
  text-align: center;
`;

const Title = styled(Typography)`
  margin: 1rem 0;
`;

const Header = styled.div`
  display: flex;
  justify-content: center
`;

const DailyData = ({ init, dailyData, getDailyData }) => {
  const [day, setDay] = useState(new Date());

  const onPrevious = useCallback(() => setDay(subDays(day, 1)), [day]);
  const onNext = useCallback(() => setDay(addDays(day, 1)), [day]);
  const onDateChange = useCallback((event) => {
    const newDay = parse(event.target.value, 'yyyy-MM-dd', new Date());
    setDay(isFuture(newDay) ? new Date() : newDay);
  }, []);

  useEffect(() => {
    if (init.success && isValid(day)) {
      getDailyData(day);
    }
  }, [init.success, getDailyData, day]);

  if (!init.success) return null;

  const lastDay = isToday(day);
  const firstDay = isSameDay(day, init.value.minDate);

  return (
    <StyledContainer disableGutters>
      <Header>
        <IconButton onClick={onPrevious} disabled={firstDay}><ArrowBackIosIcon /></IconButton>
        <TextField
          id="date"
          label="Date"
          type="date"
          value={isValid(day) ? format(day, 'yyyy-MM-dd') : ''}
          inputProps={{
            min: format(init.value.minDate, 'yyyy-MM-dd'),
            max: format(new Date(), 'yyyy-MM-dd'),
          }}
          InputLabelProps={{
            shrink: true,
          }}
          onChange={onDateChange}
        />
        <IconButton onClick={onNext} disabled={lastDay}><ArrowForwardIosIcon /></IconButton>
      </Header>
      {dailyData.onGoing && (<Loader />)}
      {!isValid(day) && (
        <Title variant="h4">Sélectionnez une date</Title>
      )}
      {dailyData.errors.length > 0 && (
        <Title variant="h4">Erreur de connexion au parc</Title>
      )}
      {dailyData.success && isValid(day) && dailyData.value.map((turbineData) => (
        <div key={turbineData.name}>
          <Typography variant="h4">{turbineData.name}</Typography>
          <Chart
            options={{
              plotOptions: {
                bar: {
                  horizontal: false,
                },
              },
              dataLabels: {
                enabled: false,
              },
              xaxis: {
                categories: turbineData.labels,
              },
              yaxis: {
                max: init.value.turbinePower,
                labels: {
                  formatter: (value) => parseInt(value, 10),
                },
              },
              stroke: {
                curve: 'smooth',
              },
            }}
            series={[{
              name: 'Production',
              data: turbineData.power,
            }]}
            type="line"
            height="300px"
          />
        </div>
      ))}
    </StyledContainer>
  );
};

DailyData.propTypes = {
  init: requestType(initType).isRequired,
  dailyData: requestType(dailyDataType).isRequired,
  getDailyData: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  init: state.windFarm.init,
  dailyData: state.windFarm.dailyData,
});

const mapDispatchToProps = {
  getDailyData: duck.getDailyData,
};

export default connect(mapStateToProps, mapDispatchToProps)(DailyData);
