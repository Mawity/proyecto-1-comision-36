import React from 'react';
import EmojiObjectsIcon from '@material-ui/icons/EmojiObjects';

class ShowSolution extends React.Component {

    render() {
        return (
            <button disabled={this.props.isDisabled} onClick={this.props.onClick} className="showSolution">
                <EmojiObjectsIcon/>
            </button>
        );
    }
}

export default ShowSolution;