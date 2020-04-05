import { shape, string } from 'prop-types';

// eslint-disable-next-line import/prefer-default-export
export const User = shape({
  firstName: string,
  lastName: string,
  email: string,
});
