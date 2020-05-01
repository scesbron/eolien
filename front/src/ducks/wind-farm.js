import {
  call, put, select, takeLatest,
} from 'redux-saga/effects';
import * as api from '../api';
import { getErrors } from './utils';

export const INIT_START = 'WIND_FARM_INIT_START';
export const INIT_SUCCESS = 'WIND_FARM_INIT_SUCCESS';
export const INIT_ERROR = 'WIND_FARM_INIT_ERROR';
export const GET_STATUS_START = 'WIND_FARM_GET_STATUS_START';
export const GET_STATUS_SUCCESS = 'WIND_FARM_GET_STATUS_SUCCESS';
export const GET_STATUS_ERROR = 'WIND_FARM_GET_STATUS_ERROR';

export const initialize = () => ({ type: INIT_START });
export const initialized = (data) => ({ type: INIT_SUCCESS, payload: data });
export const getStatus = () => ({ type: GET_STATUS_START });
export const updateStatus = (data) => ({ type: GET_STATUS_SUCCESS, payload: data });
export const setInitErrors = (errors) => ({ type: INIT_ERROR, payload: errors });
export const setGetStatusErrors = (errors) => ({ type: GET_STATUS_ERROR, payload: errors });

export const getSessionId = (state) => state.windFarm.init.value.sessionId;
export const getHandle = (state) => state.windFarm.init.value.handle;

export function* initializeSaga() {
  try {
    const response = yield call(api.windFarm.initialize);
    yield put(initialized(response.data));
  } catch (error) {
    yield put(setInitErrors(getErrors(error)));
  }
}

export function* statusSaga() {
  try {
    const sessionId = yield select(getSessionId);
    const handle = yield select(getHandle);
    const response = yield call(api.windFarm.status, sessionId, handle);
    yield put(updateStatus(response.data));
  } catch (error) {
    yield put(setGetStatusErrors(getErrors(error)));
  }
}

export function* sagas() {
  yield takeLatest(INIT_START, initializeSaga);
  yield takeLatest(GET_STATUS_START, statusSaga);
}

// Reducers

const initialRequestState = {
  onGoing: false,
  success: false,
  errors: [],
  value: undefined,
};

export const initialState = {
  init: initialRequestState,
  status: initialRequestState,
};

export const reducer = (state = initialState, action) => {
  const { payload } = action;

  switch (action.type) {
    case INIT_START:
      return {
        ...state,
        init: { ...initialRequestState, onGoing: true },
        status: initialRequestState,
      };
    case INIT_SUCCESS:
      return {
        ...state,
        init: {
          ...initialRequestState,
          success: true,
          value: payload,
        },
      };
    case INIT_ERROR:
      return {
        ...state,
        init: {
          ...initialRequestState,
          errors: payload,
        },
      };
    case GET_STATUS_START:
      return {
        ...state,
        status: {
          ...state.status, onGoing: true, success: false, errors: [],
        },
      };
    case GET_STATUS_SUCCESS:
      return {
        ...state,
        status: {
          ...initialRequestState,
          success: true,
          value: state.status.value ? state.status.value.map((turbine) => {
            const newTurbine = {};
            const apiTurbine = payload.find((item) => item.name === turbine.name) || {};
            Object.keys(turbine).forEach((key) => {
              newTurbine[key] = apiTurbine[key] || turbine[key];
            });
            return newTurbine;
          }) : payload,
        },
      };
    case GET_STATUS_ERROR:
      return {
        ...state,
        status: {
          ...initialRequestState,
          errors: payload,
        },
      };
    default:
      return state;
  }
};
