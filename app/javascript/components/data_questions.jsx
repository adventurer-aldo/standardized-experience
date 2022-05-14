import React from 'react'
import ReactDOM from 'react-dom'

function chunkArrayInGroups(arr, size) {
  var myArray = [];
  for(var i = 0; i < arr.length; i += size) {
    myArray.push(arr.slice(i, i+size));
  }
  return myArray;
}

const pages = chunkArrayInGroups(questions, 10)

class Question extends React.Component {
  constructor(props) {
    super(props);
    this.state = { page: 1, max: pages.length }
  };

  handleClick = (operation) => {
    let a = this.state.page;
    if (operation == '+') {
      this.setState({page: a + 1, max: this.state.max});
    } else if (operation == '-' && this.state.page > 1) {
      this.setState({page: a - 1, max: this.state.max});
    } else if (operation == '++') {
      this.setState({page: this.state.max, max: this.state.max});
    } else if (operation == '--') {
      this.setState({page: 1, max: this.state.max});
    };
  }

  render() { return <div id='page_questions'><div id='divider'><button onClick={() => this.handleClick('+') }/></div>
    
    <p>{this.state.max}
    </p>
  </div>
  }
}

if (document.getElementById('navigate_questions') != null) {
  ReactDOM.render(<Question />, document.getElementById('navigate_questions'))
}