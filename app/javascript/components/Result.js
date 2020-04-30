import React from "react";
import PropTypes from "prop-types";
class Result extends React.Component {
  totalscore = () => {
    let sum = 0;
    for (let num of this.props.validwords) {
      sum = sum + num.length;
    }
    console.log("sum", sum);
    return sum;
  };
  render() {
    return (
      <React.Fragment>
        <table>
          <tbody>
            <tr>
              <th>Word</th>
              <th>Score</th>
            </tr>
            {this.props.validwords.map((word, index) => (
              <tr key={index}>
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
      </React.Fragment>
    );
  }
}

export default Result;
