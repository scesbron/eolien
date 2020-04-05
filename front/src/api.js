import axios from 'axios';

import { API_BASE_URL } from './config';

export const users = {
  create: (user) => axios.post(`${API_BASE_URL}/users`, { body: { user } }),
};

export const session = {
  create: (username, password) => axios.post(`${API_BASE_URL}/login`, { user: { username, password } }),
};
