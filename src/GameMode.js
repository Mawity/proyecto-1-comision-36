import React from 'react';

class GameMode extends React.Component {

    render() {
        return (
            <button className={this.props.isDisabled ? "gamemodeNotHover" : "gamemode"} onClick={this.props.onClick} disabled={this.props.isDisabled}>
                {this.props.value == '#' ? this.props.value : 'X'}
            </button>
        );
    }
}

export default GameMode;