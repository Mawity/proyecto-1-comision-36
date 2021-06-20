import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import Game from './Game';
import ToggleButton from '@material-ui/lab/ToggleButton';
import PlayCircleOutlineIcon from '@material-ui/icons/PlayCircleOutline';
import HelpOutlineIcon from '@material-ui/icons/HelpOutline';

ReactDOM.render(
  <Game />,
  document.getElementById('root')
);
