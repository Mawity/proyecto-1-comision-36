import React from 'react';

class Clue extends React.Component {
    render() {
        const clue = this.props.clue;
        const clueClass = this.props.clueClass;
        return (
            <div className={clueClass == 0 ? "clue" : "sat"} >
                {clue.map((num, i) =>
                    <div key={i}>
                        {num}
                    </div>
                )}
            </div>
        );
    }
}

export default Clue;