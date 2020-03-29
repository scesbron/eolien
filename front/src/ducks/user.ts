import { AnyAction } from 'redux';
import { put, call, takeLatest } from 'redux-saga/effects';

import { User } from '../types';
import * as api from '../api';

// Constants

export const REGISTER = 'REGISTER';
export const LOGIN = 'LOGIN';
export const SET_ERRORS = 'SET_ERRORS';
export const UPDATE = 'UPDATE';

// Actions

export const register = (user: User) => ({ type: REGISTER, payload: user });

export const login = (email: string, password: string) => (
  { type: LOGIN, payload: { email, password } }
);

export const updateUser = (user: User) => ({ type: UPDATE, payload: user });
export const setErrors = (errors: string[]) => ({ type: SET_ERRORS, payload: errors });
// Sagas

export function* registerSaga({ payload: user }: AnyAction) {
  try {
    const response = yield call(api.users.create, user);
    yield put(updateUser(response.data));
  } catch (error) {
    yield put(setErrors([error.message]));
  }
}

export function* loginSaga({ payload: { email, password } }: AnyAction) {
  try {
    const response = yield call(api.session.create, email, password);
    yield put(updateUser(response.data));
  } catch (error) {
    yield put(setErrors([error.message]));
  }
}

export function* sagas() {
  yield takeLatest(REGISTER, registerSaga);
  yield takeLatest(LOGIN, loginSaga);
}

// Reducers

export const initialState = {
  user: {},
  errors: [],
};

export const reducer = (state = initialState, action: AnyAction) => {
  const { payload } = action;

  switch (action.type) {
    case UPDATE:
      return { ...state, user: payload };
    case SET_ERRORS:
      return { ...state, errors: payload };
    default:
      return state;
  }
};
