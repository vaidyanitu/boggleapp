import React from "react";
import PropTypes from "prop-types";
import axios from "axios";
import Board from "./Board";

class App extends React.Component {
  state = {};
  _isMounted = false;

  constructor() {
    super();
    this.state = {
      board: [],
      value: null,
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

  render() {
    console.log("value", this.state.value);

    return (
      <React.Fragment>
        <h1>Boggle Game</h1>
        <Board board={this.state.board} />
      </React.Fragment>
    );
  }
}

export default App;
