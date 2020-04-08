import React from "react";
import axios from "axios";
import Board from "./Board";
import Search from "./Search";

class App extends React.Component {
  state = {};
  _isMounted = false;

  constructor() {
    super();
    this.state = {
      board: [],
      searchword: null,
      worlist: [],
    };
  }

  componentDidMount() {
    this.setchar();
  }

  setchar = () => {
    axios.get(`http://127.0.0.1:3000/api/chars`).then((res) => {
      const board = res.data.value;
      this.setState({ board });
    });
  };

  searchword = (word) => {
    console.log("word searched:", word);
  };

  render() {
    return (
      <React.Fragment>
        <h1>Boggle Game</h1>
        <Board board={this.state.board} />
        <Search onKeyUp={this.searchword} />
      </React.Fragment>
    );
  }
}

export default App;
