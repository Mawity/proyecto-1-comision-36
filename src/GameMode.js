import React from 'react';

class GameMode extends React.Component {

    render() {
        return (
            <button className="gamemode" onClick={this.props.onClick}>
                {this.props.value == '#' ? this.props.value : 'X'}
            </button>
        );
    }
}

export default GameMode;