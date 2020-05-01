import React from "react";
import PropTypes from "prop-types";
class Validwords extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const listItems = Object.keys(this.props.wordslist).map((key) => {
      return <li key={key}>{this.props.wordslist[key]}</li>;
    });

    return (
      <React.Fragment>
        <h2>Words:</h2>
        <ul style={{ MarginTop: "30px" }}>{listItems}</ul>
      </React.Fragment>
    );
  }
}

Validwords.propTypes = {
  wordlist: PropTypes.node,
};
export default Validwords;
