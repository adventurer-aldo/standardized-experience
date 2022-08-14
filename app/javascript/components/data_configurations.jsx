import React from "react";
import ReactDOM from "react-dom";
import Butao from './butao.jsx';

class Focus extends React.Component {
  state = {focus: 0}

  handleClick = (index) => this.setState({ focus: index })

  render() { return <div>
    <div className="btn-group" role="group" aria-label="Basic example">
        <Butao index={0} active={this.state.focus===0} text={"Tudo"} onClick={this.handleClick} />
        <Butao index={1} active={this.state.focus===1} text={"1º Teste"} onClick={this.handleClick} />
        <Butao index={2} active={this.state.focus===2} text={"2º Teste"} onClick={this.handleClick} />
    </div>
        <input type='hidden' name='focus' value={this.state.focus} />
  </div>
  }
}

document.addEventListener('turbo:load', () => {
  if (document.getElementById('focus') != null) {
    ReactDOM.render(<Focus />, document.getElementById('focus'))
  }
})