import React from 'react';
import PlayCircleOutlineIcon from '@material-ui/icons/PlayCircleOutline';
import HelpOutlineIcon from '@material-ui/icons/HelpOutline';

class ShowSolution extends React.Component {

    render() {
        return (
            <button disabled={this.props.isDisabled} onClick={this.props.onClick} className="showSolution">
                {this.props.isPressed ? <PlayCircleOutlineIcon/> : <HelpOutlineIcon/>}
            </button>
        );
    }
}

export default ShowSolution;