import React from 'react'
import Button from 'react-bootstrap/Button'

class Butao extends React.Component {
  constructor(props) {
    super(props);
  }

  handleClick = () => this.props.onClick(this.props.index)

  render() { 
    return <Button variant='outline-primary' type='button' active={this.props.active} onClick={this.handleClick}>{this.props.text}</Button>
  }
};

export default Butao;