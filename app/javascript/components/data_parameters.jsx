import React from 'react'
import ReactDOM from 'react-dom'
import ButtonGroup from 'react-bootstrap/ButtonGroup'
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

class Parameters extends React.Component {
    state = {
        activeIndexesD: parameters
      }
  
    handleClick = (index) => { 
      let b = this.state.activeIndexesD;
      if (this.state.activeIndexesD.includes(index) ) {
        b.splice(b.indexOf(index), 1)
      } else {
        b.push(index)
      };
      this.setState({ activeIndexesD: b });
    }
  
  
    render() {
      return <div>Selecione os parâmetros. &ensp;
      <ButtonGroup>
        <Butao text="Rigoroso" index={0} active={ this.state.activeIndexesD.includes(0) } onClick={ this.handleClick } />
        <input name='parameters' value={JSON.stringify(this.state.activeIndexesD)} type='hidden' />
      </ButtonGroup>
      </div>
    }
}

if (document.getElementById('parameters') != null ) {
    ReactDOM.render(<Parameters />, document.getElementById('parameters'))
}