import React from 'react';
import cn from 'classnames';

export default class Like extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      isClicked: false
    }
  }

  handleClick (e) {
    e.preventDefault()
    this.setState((prev) => {return {isClicked: !prev.isClicked}})
  }
	render() {
		return (
			<button type="button" className={cn("restaurant-favorite", this.state.isClicked && "is-active")} onClick={this.handleClick.bind(this)}>
        <span>Save</span>
      </button>
		)
	}
}
