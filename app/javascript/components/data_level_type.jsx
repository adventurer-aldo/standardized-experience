import React from "react"
import ReactDOM from "react-dom"

class QType extends React.Component {
  state = {
    activeIndexes: types
  }

  handleClick = (index) => { 
    let a = this.state.activeIndexes;
    if (this.state.activeIndexes.includes(index) ) {
      if (a.length > 1) { a.splice(a.indexOf(index), 1) }
    } else {
      a.push(index)
    };
    this.setState({ activeIndexes: a });
  }

  render() {
    return <div><b>Select the type:</b> 
      <MyClickable name="Open" index={0} isActive={ this.state.activeIndexes.includes(0) } onClick={ this.handleClick } />
      <MyClickable name="Choice" index={1} isActive={ this.state.activeIndexes.includes(1) } onClick={ this.handleClick }/>
      <MyClickable name="Multi-Choice" index={2} isActive={ this.state.activeIndexes.includes(2) } onClick={ this.handleClick }/>
      <MyClickable name="Veracity" index={3} isActive={ this.state.activeIndexes.includes(3) } onClick={ this.handleClick }/>
      <MyClickable name="Caption" index={4} isActive={ this.state.activeIndexes.includes(4) } onClick={ this.handleClick }/>
      <MyClickable name="Formula" index={5} isActive={ this.state.activeIndexes.includes(6) } onClick={ this.handleClick }/>
      <MyClickable name="Table" index={6} isActive={ this.state.activeIndexes.includes(5) } onClick={ this.handleClick }/>
      <input name='types' value={JSON.stringify(this.state.activeIndexes)} type='hidden' />
    </div>
  }
}
class Level extends React.Component {
  state = {
    level: level
  }

  handleClick = (index) => this.setState({ level: index })

  render() {
    return <div><b>Nível:</b> 
      <MyClickable name="1º Teste" index={1} isActive={ this.state.level===1 } onClick={this.handleClick} />
      <MyClickable name="2º Teste" index={2} isActive={ this.state.level===2 } onClick={this.handleClick} />
      <MyClickable name="Exame" index={3} isActive={ this.state.level===3 } onClick={this.handleClick} />
      <input name='level' value={this.state.level} type='hidden' />
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

if (document.getElementById('questiontype') != null) {
  ReactDOM.render(<QType />, document.getElementById('questiontype'))
  ReactDOM.render(<Level />, document.getElementById('levels'))
}