import React from 'react';
import PengineClient from './PengineClient';
import Board from './Board';
import GameMode from './GameMode';
import ShowSolution from './ShowSolution';
import { HealingTwoTone } from '@material-ui/icons';

class Game extends React.Component {

  pengine;

  constructor(props) {
    super(props);
    this.state = {
      gameGrid: null,
      auxGrid: null,
      solvedGrid: null,
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
    this.setState({
      waiting: true
    });


    const queryInit = 'init(PistasFilas, PistasColumns, Grilla)';
    this.pengine.query(queryInit, (success, response) => {
      if (success) {
        this.setState({
          gameGrid: response['Grilla'],
          auxGrid:  response['Grilla'],
          rowClues: response['PistasFilas'],
          colClues: response['PistasColumns']
        });

        const rowCluesS = JSON.stringify(response['PistasFilas']);
        const colCluesS = JSON.stringify(response['PistasColumns']);
        const arrayVacioFilas = new Array(response['Grilla'].length);
        const arrayVacioColumnas = new Array(response['Grilla'][0].length);

        this.setState({
          correctRow: arrayVacioFilas.fill(0),
          correctCol: arrayVacioColumnas.fill(0)        
        });

        const querySolve = 'getSolution(' + rowCluesS + ',' + colCluesS + ', Solution)';
        this.pengine.query(querySolve, (success, response) => {
          if (success) {
            this.setState({
              solvedGrid: response['Solution']
            });
          }
        });
      
      }
    });




    this.setState({
      waiting: false
    });
  }

  handleClick(i, j) {
    // No action on click if we are waiting.
    if (this.state.waiting) {
      return;
    }
    // Build Prolog query to make the move, which will look as follows:
    // put("#",[0,1],[], [],[["X","_","_","_","_"],["X","_","X","_","_"],["X","_","_","_","_"],["#","#","#","_","_"],["_","_","#","#","#"]], GrillaRes, FilaSat, ColSat)
    const squaresS = JSON.stringify(this.state.gameGrid);
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
          gameGrid: response['GrillaRes'],
          auxGrid:  response['GrillaRes'],
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
    var areAllCorrect = true;
    var i=this.state.correctRow.length;

    while(i>=0 && areAllCorrect){
      if(this.state.correctRow[i-1] == 0){
        areAllCorrect = false;
      }
      i--;
    }

    var j = this.state.correctCol.length;
    
    while(j>=0 && areAllCorrect){
      if(this.state.correctCol[j-1] == 0){
        areAllCorrect = false;
      }
      j--;
    }

    if(areAllCorrect){
      this.setState({
        gameStatus: "You win!"
      })
    }else{
      this.setState({
        gameStatus: "Game in progress"
      })
    }
    
  }

  handleShowSolution(){
    if(this.state.waiting){
      return;
    }



    if(this.state.gameStatus == "Game in progress"){
      this.setState({
        gameStatus: "Showing solution",
        gameGrid: this.state.solvedGrid
      })
    }else{
      this.setState({
        gameStatus: "Game in progress",
        gameGrid: this.state.auxGrid
      })
    }
  }



  render() {
    if (this.state.gameGrid === null) {
      return null;
    }
    return (
      <div className="game">
        <Board
          playable={this.state.gameStatus == "Game in progress" ? true : false}
          gameGrid={this.state.gameGrid}
          rowClues={this.state.rowClues}
          colClues={this.state.colClues}
          rowCluesSat={this.state.correctRow}
          colCluesSat={this.state.correctCol}
          onClick={(i, j) => this.handleClick(i,j)}
        />

        <GameMode
          isDisabled={this.state.gameStatus == "Game in progress" ? false : true}
          value={this.state.gameMode}
          onClick={() => this.handleMode()}        
        />

        <ShowSolution
          value={"toggle"}
          isPressed={this.state.gameStatus == "Showing solution" ? true : false}
          isDisabled={this.state.gameStatus == "You win!" ? true : false}
          onClick={() => this.handleShowSolution()}
        />

        <HealingTwoTone
        
        />

        <div className="gameInfo">
          {this.state.gameStatus}
        </div>

      </div>
    );
  }
}

export default Game;
