import React from "react";
import PropTypes from "prop-types";
class Validwords extends React.Component {
  constructor(props) {
    super(props);
    console.log("props", this.props.wordslist);
  }
  // getwordlist(){
  //   wordlist=this.props.wordslist;
  //   return
  // }

  render() {
    const listItems = Object.keys(this.props.wordslist).map((key) => {
      return <li key={key}>{this.props.wordslist[key]}</li>;
    });

    return (
      <React.Fragment>
        Wordlist:
        <ul>{listItems}</ul>
      </React.Fragment>
    );
  }
}

Validwords.propTypes = {
  wordlist: PropTypes.node,
};
export default Validwords;
