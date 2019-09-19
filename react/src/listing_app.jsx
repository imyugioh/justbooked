import React from 'react'
import ReactDOM from 'react-dom'
import {AppContainer} from 'react-hot-loader'
import Listings from './components/Listings';

ReactDOM.render(
  <AppContainer>
    <Listings/>
  </AppContainer>,
  document.getElementById('listing-app')
);
