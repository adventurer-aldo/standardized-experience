import React from 'react'
import ReactDOM from 'react-dom'

class Answers extends React.Component {
    constructor(props) {
    super(props);
    }

    render() { return <div className="wrapper">
    {this.props.options.map((item, index) =>
          item.delete !== true ? (
            <div className="input-group" key={"" + index}>
              <input required='required' type="text" className="form-control rounded-0" name='answer[]' placeholder="Informação satisfaz a pergunta." aria-label="Resposta" aria-describedby="basic-addon1" />
              {this.props.options.filter(function(answer){return !answer.delete}).length > 1 ? (
              <span className="input-group-text rounded-0" id="basic-addon2">
                <button
                  type='button'
                  className="bg-transparent border-0"
                  tabIndex="-1"
                  onClick={() => this.props.onClick(index)}
                ><i className="fa fa-minus"></i>
                </button>
              </span>) : null }
            </div>
          ) : null
      )}
  </div>
  }
}
    
class Choices extends React.Component {
  constructor(props) {
  super(props);
  }

  state = {image: {"0": null}}

  onImageChange = (event, index) => {
    if (event.target.files && event.target.files[0]) {
      let reader = new FileReader();
      reader.onload = (e) => {
        let a = this.state.image
        a[index] = e.target.result;
        this.setState({image: a});
      };
      reader.readAsDataURL(event.target.files[0]);
    }
  }
  
  render() { return <div className="wrapper">
    {this.props.options.map((item, index) =>
          item.delete !== true ? (
            <div className="input-group" key={"" + index}>
              <input required='required' type="text" className="form-control rounded-0" name={'choices[' + JSON.stringify(index)  + '][text]'} placeholder="Alternativa que iludirá o leitor." aria-label="Escolha" aria-describedby="basic-addon1" />
              <span className="input-group-text" id="basic-addon2">
                <button type="button" className='bg-transparent border-0' data-bs-toggle="modal" data-bs-target={'#choiceImage' + JSON.stringify(index)}>
                  <i className="fa fa-picture-o"></i>
                </button>
                <div className="bg-opacity-50 bg-dark modal fade" id={'choiceImage' + JSON.stringify(index)} tabIndex="-1" aria-labelledby={'choiceLabel' + JSON.stringify(index)} aria-hidden="true">
                  <div className="modal-dialog">
                    <div className="modal-content">
                      <div className="modal-header">
                        <h5 className="modal-title text-center" id={'choiceLabel' + JSON.stringify(index)}>Anexar Imagem à Escolha</h5>
                        <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      <div className="modal-body text-start">
                      <img className='w-100' src={this.state.image[JSON.stringify(index)]}/>
                        <br />
                        Carregue a imagem: <input name={'choices[' + JSON.stringify(index)  + '][image]'} onChange={event => this.onImageChange(event, index)} className='form-control' type='file' accept="image/*" />
                        <span className='fs-7 text-muted'>{index}Se quiser eliminar esta imagem por completo., terá que eliminar a escolha também.
                        </span>
                      </div>
                      <div className="modal-footer">
                        <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                      </div>
                    </div>
                  </div>
                </div>
              </span>
                <span className="input-group-text rounded-0" id="basic-addon2">
                  <button
                    type='button'
                    className="bg-transparent border-0"
                    tabIndex="-1"
                    onClick={() => this.props.onClick(index)}
                  ><i className="fa fa-minus"></i>
                  </button>
                </span>
            </div>
          ) : null
      )}
  </div>
  }
}

class Ansices extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      answers: [{filed: ""}],
      choices: []
    }
  }
  
  componentDidMount() {
    var allArr = [];
    for (var i=0;i<choices;i++) {
      allArr = allArr.concat([{filed: ""}]);
    }
    this.setState({ answers: this.state.answers,
      choices: this.state.choices.concat(allArr)
    });
  }
  
  handleAddAnswer = () => {
    var newArr = {
      filed: "",
    };
    this.setState({
      answers: this.state.answers.concat(newArr),
      choices: this.state.choices
    });
  }
  
  handleAddChoice = () => {
    var newArr = {
      filed: "",
    };
    this.setState({ answers: this.state.answers,
      choices: this.state.choices.concat(newArr),
    });
  }

  handleRemoveAnswer = (index) => {
    this.state.answers[index].delete = true;
    this.setState((prevState) => ({
      answers: [...prevState.answers],
      choices: this.state.choices
    }));
  }
  
  handleRemoveChoice = (index) => {
    this.state.choices[index].delete = true;
    this.setState((prevState) => ({ answers: this.state.answers,
      choices: [...prevState.choices],
    }));
  }

  render() { return <div className='d-grid rounded overflow-hidden'>
    <button type='button' className="btn btn-primary rounded-0" onClick={ this.handleAddAnswer } tabIndex='-1'>
      <i className="fa fa-plus align-middle"></i>&ensp;Respostas</button>
    <Answers options={this.state.answers} onClick={ this.handleRemoveAnswer }/>
    <button type='button' className="btn btn-primary rounded-0" onClick={ this.handleAddChoice } tabIndex='-1'>
      <i className="fa fa-plus align-middle"></i>&ensp;Escolhas</button>
    <Choices options={this.state.choices} onClick={ this.handleRemoveChoice } />
  </div>

  }
}
document.addEventListener('turbo:load', () => {
  if (document.getElementById('ansices') != null) {
      ReactDOM.render(<Ansices />,
      document.getElementById('ansices'))
  };
})