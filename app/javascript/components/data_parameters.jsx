import React from 'react'
import ReactDOM from 'react-dom'
import Butao from './butao.jsx'

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
      return <div>Parâmetros? &ensp;
      <Butao text="Rigoroso" index={0} active={ this.state.activeIndexesD.includes(0) } onClick={ this.handleClick } />
      <Butao text="Ordenado" index={1} active={ this.state.activeIndexesD.includes(1) } onClick={ this.handleClick } />
      <input name='parameters' value={JSON.stringify(this.state.activeIndexesD)} type='hidden' />
      </div>
    }
}

document.addEventListener('turbo:load', () => {
  if (document.getElementById('parameters') != null ) {
      ReactDOM.render(<Parameters />, document.getElementById('parameters'))
  }
})