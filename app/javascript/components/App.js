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
  // state = {
  //   board: [],
  //   searchword: "",
  //   boardchars: "",
  //   message: "",
  //   wordlist: [],
  //   validwords: [],
  //   showMatrix: false,
  //   minutes: 1,
  //   seconds: 0,
  //   dontshowResult: true,
  // };

  constructor() {
    super();
    this.state = this.InitialState;
    this.getvalidwords = this.getvalidwords.bind(this);
  }

  componentDidMount() {
    this.setchar();
    passCsrfToken(document, axios);
  }

  componentWillUnmount() {
    this._isMounted = false;
    clearInterval(this.myTimer);
  }

  get InitialState() {
    return {
      board: [],
      searchword: "",
      boardchars: "",
      message: "",
      wordlist: [],
      validwords: [],
      showMatrix: false,
      minutes: 1,
      seconds: 0,
      dontshowResult: true,
    };
  }

  myTimer() {
    setInterval(() => {
      const { seconds, minutes } = this.state;
      if (seconds > 0) {
        this.setState(({ seconds }) => ({
          seconds: seconds - 1,
        }));
      }
      if (seconds === 0) {
        if (minutes === 0) {
          clearInterval(this.myTimer);
          this.setState({ dontshowResult: false });
        } else {
          this.setState(({ minutes }) => ({
            minutes: minutes - 1,
            seconds: 59,
          }));
        }
      }
    }, 1000);
  }

  setboardchars() {
    let boardchars = "";
    this.state.board.map((row, i) => {
      {
        row.map((col, j) => {
          boardchars += col;
        });
      }
    });
    if (this._isMounted) {
      this.setState({ boardchars }, async () => {
        await this.setworddictionary();
      });
    }
  }

  setworddictionary() {
    const post = {
      boardchars: this.state.boardchars,
    };
    axios.post("/api/word", post).then((response) => {
      var result = response.data.value.raw_body;
      if (this._isMounted) {
        this.setState({ wordlist: result });
      }
    });
  }

  setchar = () => {
    this._isMounted = true;
    axios.get(`http://127.0.0.1:3000/api/board`).then((res) => {
      const board = res.data.value;
      if (this._isMounted) {
        this.setState({ board });
        this.setboardchars();
      }
    });
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
    this.setState({ showMatrix: true }, this.myTimer());
  };

  resetGame = () => {
    var nstate = this.InitialState;
    this.setState(nstate);
    this.setchar();
    this.setState({ showMatrix: true, minutes: 1 });
  };

  render() {
    const mystyle = {
      width: "50%",
      padding: "20px",
    };
    return (
      <div
        className="Container"
        style={{ marginTop: "50px", marginLeft: "50px" }}
      >
        <h1>Boggle Game</h1>
        {this.state.showMatrix == false ? (
          <button onClick={this.getvalidwords}>Start</button>
        ) : (
          <React.Fragment>
            <button onClick={this.resetGame}>New Board</button>
            <br />
            {this.state.dontshowResult == true ? (
              <div style={{ width: "100%", overflow: "hidden" }}>
                <Timer
                  minutes={this.state.minutes}
                  seconds={this.state.seconds}
                />
                <div style={{ width: "600px", float: "left" }}>
                  <Board board={this.state.board} />
                  <Search
                    val={this.state.searchword}
                    onKeyUp={this.searchword.bind(this)}
                  />
                  <Appnotifier message={this.state.message} />
                </div>
                <div
                  style={{
                    maxHeight: "1000px",
                    overflowY: "hidden",
                    float: "left",
                  }}
                >
                  <Validwords wordslist={this.state.validwords} />
                </div>
              </div>
            ) : (
              <Result
                validwords={this.state.validwords}
                dictionary={this.state.wordlist}
              />
            )}
          </React.Fragment>
        )}
      </div>
    );
  }
}

export default App;
