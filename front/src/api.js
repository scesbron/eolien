import axios from 'axios';

import { API_BASE_URL } from './config';

const AUTH_KEY = 'Authorization';

export const user = {
  get: () => axios.get(`${API_BASE_URL}/user`),
};

export const session = {
  create: (username, password) => axios.post(`${API_BASE_URL}/login`, { user: { username, password } }),
  delete: () => axios.delete(`${API_BASE_URL}/logout`),
};

export const windFarm = {
  initialize: () => axios.get(`${API_BASE_URL}/wind_farm/init`),
  status: (sessionId, handle) => axios.get(`${API_BASE_URL}/wind_farm/status`, { params: { sessionId, handle } }),
};

export const setAuthorization = (authorization) => {
  sessionStorage.setItem(AUTH_KEY, authorization);
  axios.defaults.headers.common.Authorization = authorization;
};

export const initAuthorization = () => {
  axios.defaults.headers.common.Authorization = sessionStorage.getItem(AUTH_KEY);
};
