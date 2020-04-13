import React from 'react';
import { connect } from 'react-redux';

import { User } from '../types';

const Home = ({ user }) => (
  <div>{JSON.stringify(user, 0, 2)}</div>
);

Home.propTypes = {
  user: User.isRequired,
};

const mapStateToProps = (state) => ({
  user: state.user.current,
});

const mapDispatchToProps = {
};

export default connect(mapStateToProps, mapDispatchToProps)(Home);
