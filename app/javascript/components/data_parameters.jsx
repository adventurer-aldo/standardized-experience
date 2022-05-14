import React from 'react'
import ReactDOM from 'react-dom'

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
      return <div><b>Selecione os parâmetros:</b> 
        <MyClickable name="Rigoroso" index={0} isActive={ this.state.activeIndexesD.includes(0) } onClick={ this.handleClick } />
        <input name='parameters' value={JSON.stringify(this.state.activeIndexesD)} type='hidden' />
      </div>
    }
}

class MyClickable extends React.Component {
    handleClick = () => this.props.onClick(this.props.index)
    
    render() {
      return <button
        type='button'
        className={
          this.props.isActive ? 'btnType onType' : 'btnType offType'
        }
        onClick={ this.handleClick }
      >
        <span>{ this.props.name }</span>
      </button>
    }
  }

if (document.getElementById('parameters') != null ) {
    ReactDOM.render(<Parameters />, document.getElementById('parameters'))
}