import React from 'react';
import { connect } from 'react-redux';
import Typography from '@material-ui/core/Typography';
import Container from '@material-ui/core/Container';
import { makeStyles } from '@material-ui/core/styles';

import { User } from '../types';

const useStyles = makeStyles({
  container: {
    paddingBottom: '72px',
    textAlign: 'center',
  },
  title: {
    marginTop: '1rem',
    marginBottom: '1rem',
  },
});

const Profile = ({ user }) => {
  const classes = useStyles();
  return (
    <Container className={classes.container}>
      <Typography variant="h4" className={classes.title}>{`Bonjour ${user.firstname}`}</Typography>
      <Typography variant="h4" className={classes.title}>Données de profil par encore accessibles</Typography>
    </Container>
  );
};

Profile.propTypes = {
  user: User.isRequired,
};

const mapStateToProps = (state) => ({
  user: state.user.current,
});

const mapDispatchToProps = {
};

export default connect(mapStateToProps, mapDispatchToProps)(Profile);
