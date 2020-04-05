import { runSaga } from 'redux-saga';
import axios from 'axios';

import {
  login,
  logout,
  loginSaga,
  logoutSaga,
  updateUser,
  setErrors,
  LOGIN,
  reducer,
  initialState,
  LOGOUT,
  INITIALIZED,
  load, LOAD, initialized, loadSaga,
} from './user';
import { errorResponse, okResponse } from '../tests/test-helpers';
import { API_BASE_URL } from '../config';

const username = 'jdoe';
const password = 'password';
const errors = ['error'];
const user = { username, firstName: 'John', lastName: 'Doe' };

const loginAction = { type: LOGIN, payload: { username, password } };
const logoutAction = { type: LOGOUT };
const loadAction = { type: LOAD };
const initializedAction = (payload) => ({ type: INITIALIZED, payload });

jest.mock('axios');

describe('users duck', () => {
  afterEach(() => {
    axios.post.mockClear();
  });

  describe('actions', () => {
    it('returns the correct action for login', () => {
      expect(login(username, password)).toEqual(loginAction);
    });
    it('returns the correct action for logout', () => {
      expect(logout(username, password)).toEqual(logoutAction);
    });
    it('returns the correct action for load', () => {
      expect(load()).toEqual(loadAction);
    });
    it('returns the correct action for initialized without user', () => {
      expect(initialized()).toEqual(initializedAction());
    });
    it('returns the correct action for initialized with user', () => {
      expect(initialized(user)).toEqual(initializedAction(user));
    });
  });

  describe('reducers', () => {
    it('handles LOGIN action', () => {
      expect(reducer(initialState, loginAction)).toEqual({
        ...initialState,
        loading: true,
      });
    });
    it('handles LOGOUT action', () => {
      expect(reducer({
        ...initialState,
        current: user,
      }, logoutAction)).toEqual(initialState);
    });
    it('handles LOAD action', () => {
      expect(reducer(initialState, loadAction)).toEqual({
        ...initialState,
        initializing: true,
      });
    });
    it('handles INITIALIZED action without user', () => {
      expect(reducer(reducer(initialState, loadAction), initializedAction())).toEqual({
        ...initialState,
        initialized: true,
      });
    });
    it('handles INITIALIZED action with user', () => {
      expect(reducer(reducer(initialState, loadAction), initializedAction(user))).toEqual({
        ...initialState,
        initialized: true,
        current: user,
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

    describe('logoutSaga', () => {
      it('should call api and dispatch success action', async () => {
        const dispatched = [];
        axios.delete.mockResolvedValue(okResponse());
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, logoutSaga, logout(user));

        expect(axios.delete).toHaveBeenCalledWith(`${API_BASE_URL}/logout`);
        expect(dispatched).toEqual([updateUser()]);
      });

      it('should call api and dispatch error action from response error', async () => {
        const dispatched = [];
        axios.delete.mockRejectedValue(errorResponse(422, errors));
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, logoutSaga, logout(user));

        expect(axios.delete).toHaveBeenCalledWith(`${API_BASE_URL}/logout`);
        expect(dispatched).toEqual([setErrors(errors)]);
      });

      it('should call api and dispatch error action from network error', async () => {
        const dispatched = [];
        axios.delete.mockRejectedValue(new Error('Network error'));
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, logoutSaga, logout(user));

        expect(axios.delete).toHaveBeenCalledWith(`${API_BASE_URL}/logout`);
        expect(dispatched).toEqual([setErrors(['Network error'])]);
      });
    });

    describe('loadSaga', () => {
      it('should call api and dispatch success action', async () => {
        const dispatched = [];
        axios.get.mockResolvedValue(okResponse(user));
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, loadSaga, load());

        expect(axios.get).toHaveBeenCalledWith(`${API_BASE_URL}/user`);
        expect(dispatched).toEqual([initialized(user)]);
      });

      it('should call api and dispatch error action from response error', async () => {
        const dispatched = [];
        axios.get.mockRejectedValue(errorResponse(401, errors));
        await runSaga({
          dispatch: (action) => dispatched.push(action),
        }, loadSaga, load());

        expect(axios.get).toHaveBeenCalledWith(`${API_BASE_URL}/user`);
        expect(dispatched).toEqual([initialized()]);
      });
    });
  });
});
