import React, { useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import * as userDuck from '../ducks/user';

const Loader = ({
  children, initializing, initialized, load,
}) => {
  useEffect(() => {
    if (!initialized && !initializing) load();
  }, [initialized, initializing, load]);

  return (initializing || !initialized) ? (
    <div>Loading...</div>
  ) : (
    children
  );
};

Loader.propTypes = {
  children: PropTypes.node.isRequired,
  initializing: PropTypes.bool.isRequired,
  initialized: PropTypes.bool.isRequired,
  load: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  initializing: state.user.initializing,
  initialized: state.user.initialized,
});

const mapDispatchToProps = {
  load: userDuck.load,
};

export default connect(mapStateToProps, mapDispatchToProps)(Loader);
