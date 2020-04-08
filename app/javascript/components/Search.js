import React from "react";
import PropTypes from "prop-types";
class Search extends React.Component {
  setsearch(e) {
    if (e.keyCode === 13) {
      const val = e.target.value;
      console.log(val);
      this.props.onKeyUp(val);
      e.target.value = "";
    }
  }

  render() {
    return (
      <React.Fragment>
        <input type="text" onKeyUp={(e) => this.setsearch(e)} />
      </React.Fragment>
    );
  }
}

export default Search;
