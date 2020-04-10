import React from "react";
import PropTypes from "prop-types";
class Appnotifier extends React.Component {
  render() {
    return (
      <React.Fragment>
        <h3>{this.props.message}</h3>
      </React.Fragment>
    );
  }
}

export default Appnotifier;
