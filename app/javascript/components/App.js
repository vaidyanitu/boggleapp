import React from "react";
import PropTypes from "prop-types";
import axios from "axios";

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

        <table>
          <tbody>
            {this.state.board.map((row, i) => (
              <tr key={i} id={i}>
                {row.map((col, j) => (
                  <td key={j}>
                    <button key={j} id={j} value={col}>
                      {col}
                    </button>
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </React.Fragment>
    );
  }
}

export default App;
