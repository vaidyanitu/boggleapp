import React from "react";
import PropTypes from "prop-types";
class Result extends React.Component {
  render() {
    return <React.Fragment>{this.props.validwords}</React.Fragment>;
  }
}

export default Result;
