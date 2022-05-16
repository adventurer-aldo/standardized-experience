import React from 'react'
import ReactDOM from 'react-dom'

class Answers extends React.Component {
    constructor(props) {
    super(props);
    
    this.state = {
      other_fields: [{filed: ""}],
    };

    this.answers = 1;
    }
    
    addMoreFields() {
      this.answers++
      var newArr = {
        filed: "",
      };
      this.setState({
        other_fields: this.state.other_fields.concat(newArr),
      });
    }
    
    removeOther(index) {
      if (this.answers > 1) {
        this.answers--;
        console.log(this.state.other_fields);
        this.state.other_fields[index].delete = true;
        this.setState((prevState) => ({
          other_fields: [...prevState.other_fields],
        }));
      };
    }
    
    render() { return <div className="wrapper">
    
                {this.state.other_fields.map((item, index) =>
                    item.delete !== true ? (
                    <div className="col-12" key={"" + index}>
                        <label 
                        className="form-label wd-100 fl"
                        >
                        Resposta: 
                        </label>
                        <input
                        type="text"
                        name='answer[]'
                        className="input-data"
                        />

                        <span
                        className="addotherurl"
                        onClick={() => this.removeOther(index)}
                        >  <i className="fa fa-minus"></i>
                        </span>
                    </div>
                    ) : null
                )}

                <div
                    className="col-13"
                    onClick={() => this.addMoreFields()}
                >
                  
                    <label className="add-more">
                    <i className="fa fa-plus"></i> Resposta
                    </label>
                </div>
            </div>
     }
}
    
class Choices extends React.Component {
  constructor(props) {
  super(props);
  
  this.state = {
    other_fields: [],
  };

  this.choices = choices;
  }
  
  addMoreFields() {
  var newArr = {
    filed: "",
  };
  this.setState({
    other_fields: this.state.other_fields.concat(newArr),
  });
  }
  
  removeOther(index) {
  this.state.other_fields[index].delete = true;
  this.setState((prevState) => ({
    other_fields: [...prevState.other_fields],
  }));
  }

  componentDidMount() {
    var allArr = [];
    for (var i=0;i<choices;i++) {
      allArr = allArr.concat([{filed: ""}]);
    }
    this.setState({
      other_fields: this.state.other_fields.concat(allArr)
    });
  }
  
  render() { return <div className="wrapper">
              <div
                  className="col-13"
                  onClick={() => this.addMoreFields()}
              >
                
                  <label className="add-more">
                  <i className="fa fa-plus"></i> Escolha
                  </label>
              </div>
  
              {this.state.other_fields.map((item, index) =>
                  item.delete !== true ? (
                  <div className="col-12" key={"" + index}>
                      <label
                      className="form-label wd-100 fl"
                      >
                      Escolha: 
                      </label>
                      <input
                      type="text"
                      name='choices[]'
                      className="input-data"
                      />

                      <span
                      className="addotherurl"
                      onClick={() => this.removeOther(index)}
                      >  <i className="fa fa-minus"></i>
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
      choices: [],
      choices_cookies: choices}
  }

  render() { return <div>
    <Answers options={this.state.answers} />
    rarar
    <Choices options={this.state.choices} />
  </div>

  }
}

if (document.getElementById('ansices') != null) {
    ReactDOM.render(<Ansices />,
    document.getElementById('ansices'))
};