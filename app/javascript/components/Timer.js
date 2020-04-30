import React from "react";
import PropTypes from "prop-types";
class Timer extends React.Component {
  render() {
    const minutes = this.props.minutes;
    const seconds = this.props.seconds;

    return (
      <div>
        <h1>
          Time Remaining: {minutes}:{seconds < 10 ? `0${seconds}` : seconds}
        </h1>
      </div>
    );
  }

  // render () {
  //   return (
  //     <React.Fragment>
  //     </React.Fragment>
  //   );
  // }
}

export default Timer;
