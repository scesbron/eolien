import { AnyAction } from 'redux';
import { runSaga } from 'redux-saga';
import axios from 'axios';

import {
  login, register,
  loginSaga, registerSaga, updateUser, setErrors,
} from './user';
import { errorResponse, okResponse } from '../utils/test-helpers';
import { API_BASE_URL } from '../config';

const email = 'john@doe.com';
const password = 'password';
const errors = ['error'];
const user = { email, firstName: 'John', lastName: 'Doe' };

jest.mock('axios');
const mockedAxios = axios as jest.Mocked<typeof axios>;

describe('users duck', () => {
  afterEach(() => {
    mockedAxios.post.mockClear();
  });

  describe('loginSaga', () => {
    it('should call api and dispatch success action', async () => {
      const dispatched: AnyAction[] = [];
      mockedAxios.post.mockResolvedValue(okResponse(user));
      await runSaga({
        dispatch: (action: AnyAction) => dispatched.push(action),
      }, loginSaga, login(email, password));

      expect(mockedAxios.post).toHaveBeenCalledWith(`${API_BASE_URL}/session`, { body: { email, password } });
      expect(dispatched).toEqual([updateUser(user)]);
    });

    it('should call api and dispatch error action from response error', async () => {
      const dispatched: AnyAction[] = [];
      mockedAxios.post.mockRejectedValue(errorResponse(422, errors));
      await runSaga({
        dispatch: (action: AnyAction) => dispatched.push(action),
      }, loginSaga, login(email, password));

      expect(mockedAxios.post).toHaveBeenCalledWith(`${API_BASE_URL}/session`, { body: { email, password } });
      expect(dispatched).toEqual([setErrors(['error'])]);
    });

    it('should call api and dispatch error action from network error', async () => {
      const dispatched: AnyAction[] = [];
      mockedAxios.post.mockRejectedValue(new Error('Network error'));
      await runSaga({
        dispatch: (action: AnyAction) => dispatched.push(action),
      }, loginSaga, login(email, password));

      expect(mockedAxios.post).toHaveBeenCalledWith(`${API_BASE_URL}/session`, { body: { email, password } });
      expect(dispatched).toEqual([setErrors(['Network error'])]);
    });
  });

  describe('registerSaga', () => {
    it('should call api and dispatch success action', async () => {
      const dispatched: AnyAction[] = [];
      mockedAxios.post.mockResolvedValue(okResponse(user));
      await runSaga({
        dispatch: (action: AnyAction) => dispatched.push(action),
      }, registerSaga, register(user));

      expect(mockedAxios.post).toHaveBeenCalledWith(`${API_BASE_URL}/users`, { body: { email, password } });
      expect(dispatched).toEqual([updateUser(user)]);
    });

    it('should call api and dispatch error action from response error', async () => {
      const dispatched: AnyAction[] = [];
      mockedAxios.post.mockRejectedValue(errorResponse(422, errors));
      await runSaga({
        dispatch: (action: AnyAction) => dispatched.push(action),
      }, registerSaga, register(user));

      expect(mockedAxios.post).toHaveBeenCalledWith(`${API_BASE_URL}/users`, { body: { email, password } });
      expect(dispatched).toEqual([setErrors(['error'])]);
    });

    it('should call api and dispatch error action from network error', async () => {
      const dispatched: AnyAction[] = [];
      mockedAxios.post.mockRejectedValue(new Error('Network error'));
      await runSaga({
        dispatch: (action: AnyAction) => dispatched.push(action),
      }, registerSaga, register(user));

      expect(mockedAxios.post).toHaveBeenCalledWith(`${API_BASE_URL}/users`, { body: { email, password } });
      expect(dispatched).toEqual([setErrors(['Network error'])]);
    });
  });
});
