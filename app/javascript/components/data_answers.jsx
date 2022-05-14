import React from 'react'
import ReactDOM from 'react-dom'

class Answers extends React.Component {
    constructor(props) {
    super(props);
    
    this.state = {
      other_fields: [],
    };

    this.choices = 1;
    }
    
    addMoreFields() {
      this.choices++
      var newArr = {
        filed: "",
      };
      this.setState({
        other_fields: this.state.other_fields.concat(newArr),
      });
    }
    
    removeOther(index) {
      if (this.choices > 1) {
        this.choices--;
        console.log(this.state.other_fields);
        this.state.other_fields[index].delete = true;
        this.setState((prevState) => ({
          other_fields: [...prevState.other_fields],
        }));
      };
    }

    componentDidMount() {
      var allArr = [];
      allArr = allArr.concat([{filed: ""}]);
      this.setState({
        other_fields: this.state.other_fields.concat(allArr)
      });
    }
    
    render() { return <div className="wrapper">
    
                {this.state.other_fields.map((item, index) =>
                    item.delete !== true ? (
                    <div className="col-12" key={"" + index}>
                        <label htmlFor="inputEmailAddress"
                        className="form-label wd-100 fl"
                        >
                        Resposta: 
                        </label>
                        <input
                        type="text"
                        name='answers[]'
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
    
if (document.getElementById('answers') != null) {
    ReactDOM.render(<Answers />,
    document.getElementById('answers'))
};