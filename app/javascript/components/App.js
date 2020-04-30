import React, { Component } from "react";
import axios from "axios";
import Board from "./Board";
import Search from "./Search";
import { passCsrfToken } from "../util/helpers";
import Appnotifier from "./Appnotifier";
import Validwords from "./Validwords";
import Timer from "./Timer";
import Result from "./Result";

class App extends React.Component {
  state = {};
  _isMounted = false;

  constructor() {
    super();
    this.state = {
      board: [],
      searchword: "",
      boardchars: "",
      message: "",
      wordlist: [],
      validwords: [],
      showMatrix: false,
      minutes: 1,
      seconds: 0,
      showResult: false,
    };
    this.getvalidwords = this.getvalidwords.bind(this);
  }

  componentDidMount() {
    this.setchar();
    passCsrfToken(document, axios);
  }

  myInterval = setInterval(() => {
    const { seconds, minutes } = this.state;
    if (seconds > 0) {
      this.setState(({ seconds }) => ({
        seconds: seconds - 1,
      }));
    }
    if (seconds === 0) {
      if (minutes === 0) {
        clearInterval(this.myInterval);
        this.setState({ showResult: true });
        console.log(this.state.showResult);
      } else {
        this.setState(({ minutes }) => ({
          minutes: minutes - 1,
          seconds: 59,
        }));
      }
    }
  }, 1000);

  setboardchars() {
    let boardchars = "";
    this.state.board.map((row, i) => {
      {
        row.map((col, j) => {
          boardchars += col;
        });
      }
    });
    this.setState({ boardchars }, async () => {
      await this.setworddictionary();
    });
  }

  setworddictionary() {
    const post = {
      boardchars: this.state.boardchars,
    };
    axios.post("/api/word", post).then((response) => {
      var result = response.data.value.raw_body;
      this.setState({ wordlist: result });
    });
  }

  setchar = () => {
    axios.get(`http://127.0.0.1:3000/api/board`).then((res) => {
      const board = res.data.value;
      this.setState({ board });
      this.setboardchars();
    });
    this.myInterval;
  };

  charexists = () => {
    for (let i = 0; i < word.length - 1; i++) {
      let chr = word.substring(i, i + 1);
      if (!this.state.boardchars.includes(chr)) {
        return false;
      }
    }
    return true;
  };

  searchword = (word) => {
    console.log("boardchars", this.state.boardchars);
    console.log(this.state.wordlist);
    debugger;
    if (word.length <= 2) {
      this.setState({ message: "Word too short" });
    } else {
      word = word.toUpperCase();
      if (!this.charexists) {
        this.setState({ message: "Invalid word" });
      } else {
        const post = {
          board: this.state.board,
          word: word,
        };
        axios.post("/api/check", post).then((response) => {
          var wordadjacent = response.data.exists;
          if (wordadjacent) {
            this.checkwordexists(word);
          } else {
            this.setState({ message: "Invalid word" });
            this.setState({ searchword: word });
          }
        });
      }
    }
  };

  checkwordexists = (word) => {
    if (this.state.wordlist.includes(word)) {
      if (!this.state.validwords.includes(word)) {
        var validwordlist = this.state.validwords.concat(word);
        this.setState({ validwords: validwordlist });
        this.setState({ message: "" });
        return true;
      } else {
        this.setState({ message: "word already added!" });
        return false;
      }
    }
    this.setState({ message: "Invalid word" });
    return false;
  };

  getvalidwords = () => {
    console.log("validwords", this.state.validwords);
    this.setState({ showMatrix: true });
    // return this.state.validwords;
  };

  render() {
    // styles = StyleSheet.create({
    //   container: {
    //     flex: 1,
    //     flexDirection: "row",
    //     flexWrap: "wrap",
    //     alignItems: "flex-start", // if you want to fill rows left to right
    //   },
    //   item: {
    //     width: "50%", // is 50% of container width
    //   },
    // });
    return (
      <React.Fragment>
        <h1>Boggle Game</h1>
        {this.state.showMatrix == false ? (
          <button onClick={this.getvalidwords}>Start</button>
        ) : (
          <React.Fragment>
            {this.state.showResult == true ? (
              <Result validwords={this.state.validwords} />
            ) : (
              <div>
                <Board board={this.state.board} />
                <Search
                  val={this.state.searchword}
                  onKeyUp={this.searchword.bind(this)}
                />
                <Appnotifier message={this.state.message} />
                <Timer
                  minutes={this.state.minutes}
                  seconds={this.state.seconds}
                />
                <Validwords wordslist={this.state.validwords} />
              </div>
            )}
          </React.Fragment>
        )}
      </React.Fragment>
    );
  }
}

export default App;
