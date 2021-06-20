import React from 'react';
import ClearIcon from '@material-ui/icons/Clear';

class Square extends React.Component {
    render() {
        return (
            <button className={this.props.value == '#' ? "squarePintado" : "square" } onClick={this.props.onClick} disabled={!this.props.isDisabled}>
                {this.props.value !== '_' && this.props.value !== '#' ? <ClearIcon fontSize="large"/> : null}
            </button>
        );
    }
}

export default Square;