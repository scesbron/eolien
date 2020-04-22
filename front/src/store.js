import { createStore, applyMiddleware, combineReducers } from 'redux';
import createSagaMiddleware from 'redux-saga';
import { fork } from 'redux-saga/effects';

import * as user from './ducks/user';
import * as windFarm from './ducks/wind-farm';

const rootReducer = combineReducers({
  user: user.reducer,
  windFarm: windFarm.reducer,
});

function* rootSaga() {
  yield fork(user.sagas);
  yield fork(windFarm.sagas);
}

const configureStore = () => {
  const sagaMiddleware = createSagaMiddleware();
  const store = createStore(rootReducer, applyMiddleware(sagaMiddleware));
  sagaMiddleware.run(rootSaga);
  return store;
};

export default configureStore;
