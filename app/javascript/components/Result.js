import React from "react";
import PropTypes from "prop-types";
class Result extends React.Component {
  totalscore = () => {
    let sum = 0;
    for (let num of this.props.validwords) {
      sum = sum + num.length;
    }
    return sum;
  };
  render() {
    return (
      <React.Fragment>
        <div style={{ width: "100%" }}>
          <div style={{ width: "600px", float: "left" }}>
            <table>
              <tbody>
                <tr>
                  <th>Word</th>
                  <th>Score</th>
                </tr>
                {this.props.validwords.map((word, index) => (
                  <tr
                    key={index}
                    style={{ maxHeight: "300px", overflowY: "scroll" }}
                  >
                    <td key={"a" + index}>{word}</td>
                    <td key={"b" + index}>{word.length}</td>
                  </tr>
                ))}
                <tr>
                  <td>Total Score</td>
                  <td>{this.totalscore()}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div>
            <h3>Your Total Score:{this.totalscore()}</h3>
            <h2>Possible list of words:</h2>
            <p>{this.props.dictionary}</p>
          </div>
        </div>
      </React.Fragment>
    );
  }
}

export default Result;
