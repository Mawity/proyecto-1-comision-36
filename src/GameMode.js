import React from 'react';

class GameMode extends React.Component {
    render() {
        return (
            <button className="gamemode" onClick={this.props.onClick}>
                {this.props.value !== '_' ? this.props.value : null}
            </button>
        );
    }
}

export default GameMode;