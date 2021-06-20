import React from 'react';
import FormatPaintIcon from '@material-ui/icons/FormatPaint';
import ClearIcon from '@material-ui/icons/Clear';

class GameMode extends React.Component {

    render() {
        return (
            <button className={this.props.isDisabled ? "gamemodeNotHover" : "gamemode"} onClick={this.props.onClick} disabled={this.props.isDisabled}>
                {this.props.value == '#' ? <FormatPaintIcon fontSize="large"/> : <ClearIcon fontSize="large"/>}
            </button>
        );
    }
}

export default GameMode;