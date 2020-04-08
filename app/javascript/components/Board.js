import React from "react";
import PropTypes from "prop-types";
class Board extends React.Component {
  render() {
    return (
      <React.Fragment>
        <table>
          <tbody>
            {this.props.board.map((row, i) => (
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

export default Board;
