import React from 'react';

class Square extends React.Component {
    render() {
        return (
            <button className={this.props.value == '#' ? "squarePintado" : "square" } onClick={this.props.onClick} disabled={!this.props.isDisabled}>
                {this.props.value !== '_' && this.props.value !== '#' ? this.props.value : null}
            </button>
        );
    }
}

export default Square;