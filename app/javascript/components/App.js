import React from "react";
import axios from "axios";
import Board from "./Board";
import Search from "./Search";
import { passCsrfToken } from "../util/helpers";
import Appnotifier from "./Appnotifier";

class App extends React.Component {
  state = {};
  _isMounted = false;

  constructor() {
    super();
    this.state = {
      board: [],
      searchword: "",
      wordlist: [],
      adjacentlist: [],
      message: "",
    };
  }

  componentDidMount() {
    this.setchar();
    passCsrfToken(document, axios);
  }

  setchar = () => {
    axios.get(`http://127.0.0.1:3000/api/chars`).then((res) => {
      const board = res.data.value;
      const adjacentlist = res.data.arraylist;
      this.setState({ board });
      this.setState({ adjacentlist });
      console.log(board);
      console.log(adjacentlist);
    });
  };

  searchword = (word) => {
    let searchword = word;
    this.setState({ searchword });
    console.log("word searched:", word);
    // const post = {
    //   board: this.state.board,
    // };
    // axios.post("/api/check", post).then((response) => {
    //   console.log(response);
    //   console.log(response.data);
    // });
    let validword = this.checkword(searchword);
    if (!validword) {
      this.setState({ message: "Invalid Word" });
      // this.setState({ searchword });
    } else {
      this.setState({ searchword: "" });
    }
  };

  checkword = (word) => {
    debugger;
    let isvalid = true;
    if (word.length <= 2) {
      console.log("invalid word");
      alert("invalid word");
    } else {
      for (let i = 0; i < word.length - 1; i++) {
        let adjcell = word.substring(i, i + 2);
        adjcell = adjcell.split("").sort().join("").toUpperCase();
        let arraylist = this.state.adjacentlist;
        if (!arraylist.includes(adjcell)) {
          isvalid = false;
          break;
        }
      }
      return isvalid;
    }
  };

  render() {
    return (
      <React.Fragment>
        <h1>Boggle Game</h1>
        <Board board={this.state.board} />
        <Search
          val={this.state.searchword}
          onKeyUp={this.searchword.bind(this)}
        />

        <Appnotifier message={this.state.message} />
      </React.Fragment>
    );
  }
}

export default App;
