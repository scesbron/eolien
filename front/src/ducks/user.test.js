import { runSaga } from 'redux-saga';
import axios from 'axios';

import {
  login, register,
  loginSaga, registerSaga, updateUser, setErrors, LOGIN, reducer, initialState,
} from './user';
import { errorResponse, okResponse } from '../tests/test-helpers';
import { API_BASE_URL } from '../config';

const username = 'jdoe';
const password = 'password';
const errors = ['error'];
const user = { username, firstName: 'John', lastName: 'Doe' };

const loginAction = { type: LOGIN, payload: { username, password } };

jest.mock('axios');

describe('users duck', () => {
  afterEach(() => {
    axios.post.mockClear();
  });

  describe('actions', () => {
    it('returns the correct action for login', () => {
      expect(login(username, password)).toEqual(loginAction);
    });
  });

  describe('reducers', () => {
    it('handles LOGIN action', () => {
      expect(reducer(initialState, loginAction)).toEqual({
        ...initialState,
        loading: true,
      });
    });
  });

  describe('sagas', () => {
    describe('loginSaga', () => {
      it('should call api and dispatch success action', async () => {
        const dispatched = [];
        axios.post.mockResolvedValue(okResponse(user));
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, loginSaga, login(username, password));

        expect(axios.post).toHaveBeenCalledWith(`${API_BASE_URL}/login`, { user: { username, password } });
        expect(dispatched).toEqual([updateUser(user)]);
      });

      it('should call api and dispatch error action from response error', async () => {
        const dispatched = [];
        axios.post.mockRejectedValue(errorResponse(422, errors));
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, loginSaga, login(username, password));

        expect(axios.post).toHaveBeenCalledWith(`${API_BASE_URL}/login`, { user: { username, password } });
        expect(dispatched).toEqual([setErrors(errors)]);
      });

      it('should call api and dispatch error action from network error', async () => {
        const dispatched = [];
        axios.post.mockRejectedValue(new Error('Network error'));
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, loginSaga, login(username, password));

        expect(axios.post).toHaveBeenCalledWith(`${API_BASE_URL}/login`, { user: { username, password } });
        expect(dispatched).toEqual([setErrors(['Network error'])]);
      });
    });

    describe('registerSaga', () => {
      it('should call api and dispatch success action', async () => {
        const dispatched = [];
        axios.post.mockResolvedValue(okResponse(user));
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, registerSaga, register(user));

        expect(axios.post).toHaveBeenCalledWith(`${API_BASE_URL}/users`, { body: { user } });
        expect(dispatched).toEqual([updateUser(user)]);
      });

      it('should call api and dispatch error action from response error', async () => {
        const dispatched = [];
        axios.post.mockRejectedValue(errorResponse(422, errors));
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, registerSaga, register(user));

        expect(axios.post).toHaveBeenCalledWith(`${API_BASE_URL}/users`, { body: { user } });
        expect(dispatched).toEqual([setErrors(errors)]);
      });

      it('should call api and dispatch error action from network error', async () => {
        const dispatched = [];
        axios.post.mockRejectedValue(new Error('Network error'));
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, registerSaga, register(user));

        expect(axios.post).toHaveBeenCalledWith(`${API_BASE_URL}/users`, { body: { user } });
        expect(dispatched).toEqual([setErrors(['Network error'])]);
      });
    });
  });
});
