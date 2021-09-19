import React from 'react';
import {
  Switch,
  Route
} from 'react-router-dom';
import Home from './Home';
import Ranking from './Ranking';

export default function App() {
  return (
    <>
      <Switch>
        <Route exact path="/">
          <Home />
        </Route>
        <Route path="/channels/:channel_id/ranking">
          <Ranking />
        </Route>
      </Switch>
    </>
  );
}
