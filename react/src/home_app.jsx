import React from 'react';
import ReactDOM from 'react-dom';
import { AppContainer } from 'react-hot-loader';
import HomeSearch from './components/HomeSearch';

ReactDOM.render(
	<AppContainer>
		<HomeSearch />
	</AppContainer>,
	document.getElementById('home-search-app')
);
