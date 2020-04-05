import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { BrowserRouter as Router } from 'react-router-dom';

import configureStore from './store';
import './index.css';
import App from './App';
import { initAuthorization } from './api';
import Loader from './containers/loader';

const store = configureStore();

initAuthorization();

ReactDOM.render(
  <React.StrictMode>
    <Provider store={store}>
      <Router>
        <Loader>
          <App />
        </Loader>
      </Router>
    </Provider>
  </React.StrictMode>,
  document.getElementById('root'),
);
