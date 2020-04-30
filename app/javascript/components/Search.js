import React from "react";
import PropTypes from "prop-types";
class Search extends React.Component {
  setsearch(e) {
    if (e.keyCode === 13) {
      const val = e.target.value;
      this.props.onKeyUp(val);
      e.target.value = "";
    }
  }

  render() {
    return (
      <React.Fragment>
        <input type="text" onKeyUp={this.setsearch.bind(this)} />
      </React.Fragment>
    );
  }
}

export default Search;
