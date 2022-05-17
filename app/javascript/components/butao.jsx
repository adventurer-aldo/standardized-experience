import React from 'react'
import Button from 'react-bootstrap/Button'

class Butao extends React.Component {
  constructor(props) {
    super(props);
  }

  handleClick = () => this.props.onClick(this.props.index)

  render() { 
    return <button className={'btn btn-outline-primary' + (this.props.active === true ? ' active' : '')} type='button' onClick={this.handleClick}>{this.props.text}</button>
  }
};

export default Butao;