import { put, call, takeLatest } from 'redux-saga/effects';

import * as api from '../api';
import { getErrors } from './utils';

// Constants

export const REGISTER = 'REGISTER';
export const LOGIN = 'LOGIN';
export const SET_ERRORS = 'SET_ERRORS';
export const UPDATE = 'UPDATE';

// Actions

export const register = (user) => ({ type: REGISTER, payload: user });

export const login = (username, password) => (
  { type: LOGIN, payload: { username, password } }
);

export const updateUser = (user) => ({ type: UPDATE, payload: user });
export const setErrors = (errors) => ({ type: SET_ERRORS, payload: errors });

// Sagas

export function* registerSaga({ payload: user }) {
  try {
    const response = yield call(api.users.create, user);
    yield put(updateUser(response.data));
  } catch (error) {
    yield put(setErrors(getErrors(error)));
  }
}

export function* loginSaga({ payload: { username, password } }) {
  try {
    const response = yield call(api.session.create, username, password);
    yield put(updateUser(response.data));
  } catch (error) {
    yield put(setErrors(getErrors(error)));
  }
}

export function* sagas() {
  yield takeLatest(REGISTER, registerSaga);
  yield takeLatest(LOGIN, loginSaga);
}

// Reducers

export const initialState = {
  loading: false,
  current: undefined,
  errors: [],
};

export const reducer = (state = initialState, action) => {
  const { payload } = action;

  switch (action.type) {
    case REGISTER:
    case LOGIN:
      return { ...initialState, loading: true };
    case UPDATE:
      return { ...initialState, current: payload };
    case SET_ERRORS:
      return { ...initialState, errors: payload };
    default:
      return state;
  }
};
