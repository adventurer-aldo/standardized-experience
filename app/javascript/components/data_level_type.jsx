import React from "react"
import ReactDOM from "react-dom"
import ButtonGroup from 'react-bootstrap/ButtonGroup'
import Butao from './butao.jsx'

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
    return <div>Selecione os tipos.
    <div className='overflow-auto mb-1'>
      <div className="btn-group" role="group" aria-label="Basic example">
        <Butao text="Aberta" index={0} active={ this.state.activeIndexes.includes(0) } onClick={ this.handleClick } />
        <Butao text="Múltiplas Abertas" index={4} active={ this.state.activeIndexes.includes(4) } onClick={ this.handleClick }/>
        <Butao text="Escolha" index={1} active={ this.state.activeIndexes.includes(1) } onClick={ this.handleClick }/>
        <Butao text="Escolha-Múltipla" index={2} active={ this.state.activeIndexes.includes(2) } onClick={ this.handleClick }/>
        <Butao text="Verdadeiro/Falso" index={3} active={ this.state.activeIndexes.includes(3) } onClick={ this.handleClick }/>
        <Butao text="Formula" index={5} active={ this.state.activeIndexes.includes(5) } onClick={ this.handleClick }/>
        <Butao text="Tabela" index={6} active={ this.state.activeIndexes.includes(6) } onClick={ this.handleClick }/>
      </div>
      <input name='types' value={JSON.stringify(this.state.activeIndexes)} type='hidden' />
    </div>
    </div>
  }
}

class Level extends React.Component {
  state = {
    level: level
  }

  handleClick = (index) => this.setState({ level: index })

  render() {
    return <div className='mb-1'>Nível? &ensp; 
      <div className="btn-group" role="group" aria-label="Basic example">
        <Butao index={1} active={this.state.level===1} text={"1º Teste"} onClick={this.handleClick} />
        <Butao index={2} active={this.state.level===2} text={"2º Teste"} onClick={this.handleClick} />
        <Butao index={3} active={this.state.level===3} text={"Exame"} onClick={this.handleClick} />
      </div>
      <input name='level' value={this.state.level} type='hidden' />
    </div>
  }
}

if (document.getElementById('questiontype') != null) {
  ReactDOM.render(<QType />, document.getElementById('questiontype'))
  ReactDOM.render(<Level />, document.getElementById('levels'))
}