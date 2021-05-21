import React from 'react';
import PengineClient from './PengineClient';
import Board from './Board';
import GameMode from './GameMode';

class Game extends React.Component {

  pengine;

  constructor(props) {
    super(props);
    this.state = {
      grid: null,
      rowClues: null,
      colClues: null,
      gameMode: "#",
      gameStatus: "Game in progress",
      correctRow: null,
      correctCol: null, 
      waiting: false
    };
    this.handleClick = this.handleClick.bind(this);
    this.handlePengineCreate = this.handlePengineCreate.bind(this);
    this.pengine = new PengineClient(this.handlePengineCreate);
  }

  handlePengineCreate() {
    const queryS = 'init(PistasFilas, PistasColumns, Grilla)';
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          grid: response['Grilla'],
          rowClues: response['PistasFilas'],
          colClues: response['PistasColumns'],
        });
      }
    });
  }

  handleClick(i, j) {
    // No action on click if we are waiting.
    if (this.state.waiting) {
      return;
    }
    // Build Prolog query to make the move, which will look as follows:
    // put("#",[0,1],[], [],[["X",_,_,_,_],["X",_,"X",_,_],["X",_,_,_,_],["#","#","#",_,_],[_,_,"#","#","#"]], GrillaRes, FilaSat, ColSat)
    const squaresS = JSON.stringify(this.state.grid).replaceAll('"_"', "_"); // Remove quotes for variables.
    const gamsModeS = JSON.stringify(this.state.gameMode);
    const rowCluesS = JSON.stringify(this.state.rowClues);
    const colCluesS = JSON.stringify(this.state.colClues);
    const queryS = 'put('+ gamsModeS +', [' + i + ',' + j + ']' 
    + ', ' + rowCluesS + ',' + colCluesS + ',' + squaresS + ', GrillaRes, FilaSat, ColSat)';
    this.setState({
      waiting: true
    });
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        const pistasRowAct = this.state.correctRow.slice();
        const pistasColAct = this.state.correctCol.slice();

        pistasRowAct[i] = response['FilaSat'];
        pistasColAct[j] = response['ColSat'];

        this.setState({
          grid: response['GrillaRes'],
          correctRow: pistasRowAct,
          correctCol: pistasColAct,
          waiting: false
        }, () => this.isGameOver());

      } else {
        this.setState({
          waiting: false
        });
      }
    });
  }

  handleMode(){
    if(this.state.waiting){
      return;
    }

    if(this.state.gameMode == "#"){
      this.setState({
        gameMode: "X"
      })
    }else{
      this.setState({
        gameMode: "#"
      })
    }
  }

  isGameOver(){
    areAllCorrect = true;

    this.state.correctRow.forEach(row => {

    });



    this.state.correctRow.forEach(row => {
      this.state.correctCol.forEach(col =>{
        if(!col || !row){
          this.setState({
            gameStatus: "Game in progress"
          })      
          break;
        }
      });
    });

    ;
  }

  render() {
    if (this.state.grid === null) {
      return null;
    }
    return (
      <div className="game">
        <Board
          playable={this.state.gameStatus = "Game in progress" ? true : false}
          grid={this.state.grid}
          rowClues={this.state.rowClues}
          colClues={this.state.colClues}
          onClick={(i, j) => this.handleClick(i,j)}
        />

        <GameMode
          value={this.state.gameMode}
          onClick={() => this.handleMode()}        
        />

        <div className="gameInfo">
          {this.gameStatus}
        </div>

      </div>
    );
  }
}

export default Game;
