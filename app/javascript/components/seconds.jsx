import React from "react"
import ReactDOM  from "react-dom"

class Container extends React.Component {
  state = {
    activeIndex: 0,
    choice: 'open'
  }

  handleClick = (index) => this.setState({ activeIndex: index, choice: ['open','choice','multichoice','veracity','caption','table','formula'][this.state.activeIndex] })

  render() {
    return <div><b>Select the type:</b> 
      <MyClickable name="Open" index={0} isActive={ this.state.activeIndex===0 } onClick={ this.handleClick } />
      <MyClickable name="Choice" index={1} isActive={ this.state.activeIndex===1 } onClick={ this.handleClick }/>
      <MyClickable name="Multi-Choice" index={2} isActive={ this.state.activeIndex===2 } onClick={ this.handleClick }/>
      <MyClickable name="Veracity" index={3} isActive={ this.state.activeIndex===3 } onClick={ this.handleClick }/>
      <MyClickable name="Caption" index={4} isActive={ this.state.activeIndex===4 } onClick={ this.handleClick }/>
      <MyClickable name="Table" index={5} isActive={ this.state.activeIndex===5 } onClick={ this.handleClick }/>
      <MyClickable name="Formula" index={6} isActive={ this.state.activeIndex===6 } onClick={ this.handleClick }/>
      <input name='type' value={this.state.choice} type='hidden' />
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

ReactDOM.render(<Container />, document.getElementById('questiontype'))