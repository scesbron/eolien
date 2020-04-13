import { put, call, takeLatest } from 'redux-saga/effects';

import * as api from '../api';
import { getErrors } from './utils';
import { setAuthorization } from '../api';
import { parseApiDate } from '../utils/date';

// Constants

export const LOAD = 'LOAD';
export const LOGIN = 'LOGIN';
export const LOGOUT = 'LOGOUT';
export const SET_ERRORS = 'SET_ERRORS';
export const UPDATE = 'UPDATE';
export const INITIALIZED = 'INITIALIZED';

// Actions

export const logout = () => ({ type: LOGOUT });
export const login = (username, password) => (
  { type: LOGIN, payload: { username, password } }
);
export const load = () => ({ type: LOAD });
export const updateUser = (user) => ({ type: UPDATE, payload: user });
export const setErrors = (errors) => ({ type: SET_ERRORS, payload: errors });
export const initialized = (user) => ({ type: INITIALIZED, payload: user });

// Sagas

export function* logoutSaga() {
  try {
    yield call(api.session.delete);
    yield put(updateUser());
  } catch (error) {
    yield put(setErrors(getErrors(error)));
  }
}

export function* loginSaga({ payload: { username, password } }) {
  try {
    const response = yield call(api.session.create, username, password);
    setAuthorization(response.headers.authorization);
    yield put(updateUser(response.data));
  } catch (error) {
    yield put(setErrors(getErrors(error)));
  }
}

export function* loadSaga() {
  try {
    const response = yield call(api.user.get);
    yield put(initialized(response.data));
  } catch (error) {
    setAuthorization();
    yield put(initialized());
  }
}

export function* sagas() {
  yield takeLatest(LOGOUT, logoutSaga);
  yield takeLatest(LOGIN, loginSaga);
  yield takeLatest(LOAD, loadSaga);
}

// Reducers

export const initialState = {
  initializing: false,
  initialized: false,
  loading: false,
  current: undefined,
  errors: [],
};

const convert = (user) => (!user ? undefined : {
  ...user,
  birthDate: parseApiDate(user.birthDate),
  loans: user.loans.map((loan) => ({
    ...loan,
    date: parseApiDate(loan.date),
  })),
  shares: user.shares.map((share) => ({
    ...share,
    date: parseApiDate(share.date),
  })),
});

export const reducer = (state = initialState, action) => {
  const { payload } = action;

  switch (action.type) {
    case LOAD:
      return { ...initialState, initializing: true };
    case LOGOUT:
      return { ...state, current: undefined };
    case LOGIN:
      return { ...state, loading: true };
    case UPDATE:
      return { ...state, current: convert(payload), errors: [] };
    case INITIALIZED:
      return {
        ...state,
        initializing: false,
        initialized: true,
        current: convert(payload),
      };
    case SET_ERRORS:
      return { ...state, current: undefined, errors: payload };
    default:
      return state;
  }
};
