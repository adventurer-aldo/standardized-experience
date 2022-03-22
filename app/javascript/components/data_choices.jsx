import React from 'react'
import ReactDOM from 'react-dom'

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
        this.addMoreFields();
    }
    
    render() { return <div className="wrapper">
    
                {this.state.other_fields.map((item, index) =>
                    item.delete !== true ? (
                    <div className="col-12">
                        <label htmlFor="inputEmailAddress"
                        className="form-label wd-100 fl"
                        >
                        Choice: 
                        </label>
                        <input
                        type="text"
                        name='choice[]'
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
                    <i className="fa fa-plus"></i> Add Choice
                    </label>
                </div>
            </div>
     }
}
    
if (document.getElementById('choices') != null) {
    ReactDOM.render(<Choices />,
    document.getElementById('choices'))
};