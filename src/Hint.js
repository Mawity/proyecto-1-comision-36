import React from 'react';
import SearchIcon from '@material-ui/icons/Search';

class Hint extends React.Component {

    render() {
        return (
            <button disabled={this.props.isDisabled} onClick={this.props.onClick} className={this.props.isDisabled ? "hintNotHover" : "hint"}>
                <SearchIcon fontSize="large"/>
            </button>
        );
    }
}

export default Hint;