import React from 'react'
import ReactDOM from 'react-dom'

class Parameters extends React.Component {
    state = {
        activeIndexD: 0,
        choiceD: ''
      }
  
    handleClick = (index) => this.setState({ activeIndexD: index, choiceD: ['',':strict_order'][index] })
  
    render() {
      return <div><b>Select the parameters:</b> 
        <MyClickable name="Strict Order" index={1} isActive={ this.state.activeIndexD===1 } onClick={ this.handleClick } />
        <input name='parameters[]' value={this.state.choiceD} type='hidden' />
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