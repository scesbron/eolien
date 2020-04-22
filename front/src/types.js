import { number, shape, string } from 'prop-types';

// eslint-disable-next-line import/prefer-default-export
export const User = shape({
  firstName: string,
  lastName: string,
  email: string,
  username: string,
});

export const WindTurbineStatusType = shape({
  name: string,
  instantPower: number,
  windSpeed: number,
  disponibility: number,
  totalProduction: number,
});
