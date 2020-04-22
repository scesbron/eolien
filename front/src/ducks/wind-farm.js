import {
  call, put, select, takeLatest,
} from 'redux-saga/effects';
import * as api from '../api';
import { getErrors } from './utils';

export const INITIALIZE = 'WIND_FARM_INITIALIZE';
export const INITIALIZED = 'WIND_FARM_INITIALIZED';
export const GET_STATUS = 'WIND_FARM_GET_STATUS';
export const UPDATE_STATUS = 'WIND_FARM_UPDATE_STATUS';
export const SET_ERRORS = 'WIND_FARM_SET_ERRORS';

export const initialize = () => ({ type: INITIALIZE });
export const initialized = (data) => ({ type: INITIALIZED, payload: data });
export const getStatus = () => ({ type: GET_STATUS });
export const updateStatus = (data) => ({ type: UPDATE_STATUS, payload: data });
export const setErrors = (errors) => ({ type: SET_ERRORS, payload: errors });

export const getSessionId = (state) => state.windFarm.sessionId;
export const getHandle = (state) => state.windFarm.handle;

export function* initializeSaga() {
  try {
    const response = yield call(api.windFarm.initialize);
    yield put(initialized(response.data));
  } catch (error) {
    yield put(setErrors(getErrors(error)));
  }
}

export function* statusSaga() {
  try {
    const sessionId = yield select(getSessionId);
    const handle = yield select(getHandle);
    const response = yield call(api.windFarm.status, sessionId, handle);
    yield put(updateStatus(response.data));
  } catch (error) {
    yield put(setErrors(getErrors(error)));
  }
}

export function* sagas() {
  yield takeLatest(INITIALIZE, initializeSaga);
  yield takeLatest(GET_STATUS, statusSaga);
}

// Reducers

export const initialState = {
  initializing: false,
  initialized: false,
  sessionId: undefined,
  handle: undefined,
  status: undefined,
  errors: [],
};

export const reducer = (state = initialState, action) => {
  const { payload } = action;

  switch (action.type) {
    case INITIALIZE:
      return { ...initialState, initializing: true };
    case INITIALIZED:
      return {
        ...state,
        initializing: false,
        initialized: true,
        sessionId: payload.sessionId,
        handle: payload.handle,
        errors: [],
      };
    case UPDATE_STATUS:
      return {
        ...state,
        status: state.status ? state.status.map((turbine) => {
          const newTurbine = {};
          const apiTurbine = payload.find((item) => item.name === turbine.name) || {};
          Object.keys(turbine).forEach((key) => {
            newTurbine[key] = apiTurbine[key] || turbine[key];
          });
          return newTurbine;
        }) : payload,
      };
    case SET_ERRORS:
      return {
        ...state,
        initializing: false,
        sessionId: undefined,
        handle: undefined,
        errors: payload,
      };
    default:
      return state;
  }
};
