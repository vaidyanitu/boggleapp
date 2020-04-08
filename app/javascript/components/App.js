import React from "react";
import axios from "axios";
import Board from "./Board";
import Search from "./Search";
import { passCsrfToken } from "../util/helpers";

class App extends React.Component {
  state = {};
  _isMounted = false;

  constructor() {
    super();
    this.state = {
      board: [],
      searchword: "",
      worlist: [],
    };
  }

  componentDidMount() {
    this.setchar();
    passCsrfToken(document, axios);
  }

  setchar = () => {
    axios.get(`http://127.0.0.1:3000/api/chars`).then((res) => {
      const board = res.data.value;
      this.setState({ board });
    });
  };

  searchword = (word) => {
    this.setState({ searchword: word });
    console.log("word searched:", word);
    // const dta = { board: "test" };
    // axios
    //   .post(`http://127.0.0.1:3000/api/check`, { board: "test" })
    //   .then((res) => {
    //     console.log("here", res.data);
    //   });
    const post = {
      board: this.state.board,
    };

    axios.post("/api/check", post).then((response) => {
      console.log(response);
      console.log(response.data);
    });
    this.setState({ searchword: null });
  };

  checkword = (word) => {};
  render() {
    return (
      <React.Fragment>
        <h1>Boggle Game</h1>
        <Board board={this.state.board} />
        <Search
          val={this.state.searchword}
          onKeyUp={this.searchword.bind(this)}
        />
      </React.Fragment>
    );
  }
}

export default App;
