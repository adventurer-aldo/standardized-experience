import React from "react"
import ReactDOM from "react-dom"
import ButtonGroup from 'react-bootstrap/ButtonGroup'
import Button from 'react-bootstrap/Button'

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
      <MyClickable name="Aberto" index={0} isActive={ this.state.activeIndexes.includes(0) } onClick={ this.handleClick } />
      <MyClickable name="Múltiplas Abertas" index={4} isActive={ this.state.activeIndexes.includes(4) } onClick={ this.handleClick }/>
      <MyClickable name="Escolha" index={1} isActive={ this.state.activeIndexes.includes(1) } onClick={ this.handleClick }/>
      <MyClickable name="Escolha-Múltipla" index={2} isActive={ this.state.activeIndexes.includes(2) } onClick={ this.handleClick }/>
      <MyClickable name="Verdadeiro/Falso" index={3} isActive={ this.state.activeIndexes.includes(3) } onClick={ this.handleClick }/>
      <MyClickable name="Formula" index={5} isActive={ this.state.activeIndexes.includes(6) } onClick={ this.handleClick }/>
      <MyClickable name="Tabela" index={6} isActive={ this.state.activeIndexes.includes(5) } onClick={ this.handleClick }/>
      <input name='types' value={JSON.stringify(this.state.activeIndexes)} type='hidden' />
    </div>
  }
}

class Nivel extends React.Component {
  constructor(props) {
    super(props);
  }

  handleClick = () => this.props.onClick(this.props.index)

  render() { 
    return <Button variant='outline-primary' type='button' active={this.props.active} onClick={this.handleClick}>{this.props.text}</Button>
  }
};


class Level extends React.Component {
  state = {
    level: level
  }

  handleClick = (index) => this.setState({ level: index })

  render() {
    return <div><b>Nível: &ensp;</b> 
      <ButtonGroup>
        <Nivel index={1} active={this.state.level===1} text={"1º Teste"} onClick={this.handleClick} />
        <Nivel index={2} active={this.state.level===2} text={"2º Teste"} onClick={this.handleClick} />
        <Nivel index={3} active={this.state.level===3} text={"Exame"} onClick={this.handleClick} />
      </ButtonGroup>
      <input name='level' value={this.state.level} type='hidden' />
    </div>
  }
}


class MyClickable extends React.Component {
  handleClick = () => this.props.onClick(this.props.index)
  
  render() {
    return <span><input
      type='button'
      className="btn-check"
      autoComplete="off"
      name="level"
      id={"btn-level" + JSON.stringify(this.props.index)}
      />
    <label 
    htmlFor={"btn-level" + JSON.stringify(this.props.index)} 
    aria-pressed={this.props.isActive ? 'true' : 'false'}
    onClick={ this.handleClick }
    className="btn btn-outline-primary">{this.props.text}</label>
      <span>{ this.props.index }</span>
    </span>
  }
}

if (document.getElementById('questiontype') != null) {
  ReactDOM.render(<QType />, document.getElementById('questiontype'))
  ReactDOM.render(<Level />, document.getElementById('levels'))
}