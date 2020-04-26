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
      boardchars: [],
      adjacentlist: [],
      message: "",
    };
  }

  componentDidMount() {
    this.setchar();
    passCsrfToken(document, axios);
  }

  setboardchars() {
    let boardchars = [];
    this.state.board.map((row, i) => {
      {
        row.map((col, j) => {
          boardchars.push(col);
        });
      }
    });
    this.setState({ boardchars });
  }

  setchar = () => {
    axios.get(`http://127.0.0.1:3000/api/chars`).then((res) => {
      const board = res.data.value;
      const adjacentlist = res.data.arraylist;
      this.setState({ board });
      this.setboardchars();
      this.setState({ adjacentlist });
    });
  };

  searchword = (word) => {
    let searchword = word.toUpperCase();
    this.setState({ searchword });
    console.log("word searched:", word);
    // this.checkadj(word);
    const post = {
      board: this.state.board,
      word: searchword,
      arlist: this.state.adjacentlist,
    };
    axios.post("/api/check", post).then((response) => {
      console.log(response);
      console.log(response.data);
    });
  };

  checkword = (word) => {
    let isvalid = true;
    if (word.length <= 2) {
      console.log("invalid word");
      alert("invalid word");
    } else {
      let wordlist = this.state.adjacentlist;
      let lst = [];
      for (let i = 0; i < word.length - 1; i++) {
        let chr = word.substring(i, i + 1).toUpperCase();
        if (!this.state.boardchars.includes(chr)) {
          isvalid = false;
          console.log("invalid word");
          alert("invalid word");
          break;
        } else {
          let adjcell = word.substring(i, i + 2);
          adjcell = adjcell.split("").sort().join("").toUpperCase();
          if (!wordlist.includes(adjcell)) {
            isvalid = false;
            break;
          } else {
            const index = wordlist.indexOf(adjcell);
            // if (index > -1) {
            //   wordlist.splice(index, 1);
            // }
            lst.push(word.substring(i, i + 1));
          }
        }
      }
      console.log(lst);
      // let isright = this.checkTraversed(lst);
      return isvalid;
    }
  };

  checkadj = (word) => {
    debugger;
    let wordlist = this.state.adjacentlist;
    let lst = [];
    let searchword = word.toUpperCase();
    searchword = searchword.substring(0, 1);
    console.log(searchword);
    this.setState({ searchword });
    console.log("word searched:", word);
    let tst = [];
    for (let i = 0; i < 2; i++) {
      let chr = word.substring(i, i + 1).toUpperCase();
      let adjcell = word.substring(i, i + 1);
      adjcell = adjcell.split("").sort().join("").toUpperCase();
      const post = {
        board: this.state.board,
        word: chr,
        arlist: this.state.adjacentlist,
      };
      axios.post("/api/check", post).then((response) => {
        lst = response.data;
        console.log(response.data);
      });

      if (i > 0) {
        let nextchar = word.substring(i + 1, 1).toUpperCase();
        lst.forEach((item) => {
          tst.push(item[0]);
          item[1].forEach((x) => {
            if (x[0] == nextchar) {
              if (!tst.includes(x[1])) {
                tst.push(x[1]);
              }
            }
          });
        });
      }
    }
    console.log("lst", lst);
    console.log("tst:", tst);
    // let isright = this.checkTraversed(lst);
  };

  checkTraversed = (chr) => {
    index = "0";
    this.state.board.map((row, i) => {
      row.map((col, j) => {
        if (chr == col) {
          index = index + ij;
        }
      });
    });
    console.log(index);
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
