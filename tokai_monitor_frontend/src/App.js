import React from 'react';
import {
  Switch,
  Route
} from 'react-router-dom';
import {
  createTheme,
  ThemeProvider
} from '@mui/material/styles';
import AppBar from '@mui/material/AppBar';
import CssBaseline from '@mui/material/CssBaseline';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Home from './Home';
import Ranking from './Ranking';

const theme = createTheme();

export default function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <AppBar position="relative">
        <Toolbar>
          <Typography variant="h6" color="inherit">
            東海モニター
          </Typography>
        </Toolbar>
      </AppBar>
      <Switch>
        <Route exact path="/">
          <Home />
        </Route>
        <Route path="/channels/:channel_id/ranking">
          <Ranking />
        </Route>
      </Switch>
    </ThemeProvider>
  );
}
