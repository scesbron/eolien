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

import { format } from '../utils/date';
import { initType, requestType, monthlyDataType } from '../types';
import * as duck from '../ducks/wind-farm';
import Loader from '../components/loader';

const StyledContainer = styled(Container)`
  text-align: center;
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
    <StyledContainer>
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
        <>
          <div>Productible : {monthlyData.value.productibles.join(', ')}</div>
          <div>Labels : {monthlyData.value.labels.join(', ')}</div>
          <div>Values : {monthlyData.value.values.join(', ')}</div>
        </>
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
