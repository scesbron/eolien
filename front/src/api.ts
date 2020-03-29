import axios from 'axios';

import { API_BASE_URL } from './config';
import { User } from './types';

export const users = {
  create: (user: User) => axios.post(`${API_BASE_URL}/users`, { body: { user } }),
};

export const session = {
  create: (email: string, password: string) => axios.post(`${API_BASE_URL}/session`, { body: { email, password } }),
};
