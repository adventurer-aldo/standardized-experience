import React from 'react'
import ReactDOM from 'react-dom'

function chunkArrayInGroups(arr, size) {
  var myArray = [];
  for(var i = 0; i < arr.length; i += size) {
    myArray.push(arr.slice(i, i+size));
  }
  return myArray;
}


class Question extends React.Component {
  
  constructor(props) {
    super(props);
    this.state = { page: 1, max: this.props.pages.length }
  };

  handleClick = (operation) => {
    let a = this.state.page;
    if (operation == '+' && this.state.page < this.state.max) {
      this.setState({page: a + 1, max: this.state.max});
    } else if (operation == '-' && this.state.page > 1) {
      this.setState({page: a - 1, max: this.state.max});
    } else if (operation == '++') {
      this.setState({page: this.state.max, max: this.state.max});
    } else if (operation == '--') {
      this.setState({page: 1, max: this.state.max});
    };
  }

  handleNumber = (num) => {
    this.setState({page: num, max: this.state.max});
  }

  render() { return <div id='page_questions' className='p-1'>
  <nav aria-label="Page navigation example">
    <ul className="pagination">
    <li className={"page-item" + (this.state.page === 1 ? ' disabled' : '')} onClick={() => this.handleClick('-') }><a className="page-link" href='#navigate_questions'>First</a></li>
      <li className={"page-item" + (this.state.page === 1 ? ' disabled' : '')} onClick={() => this.handleClick('-') }><a className="page-link" href='#navigate_questions'>Previous</a></li>
      { this.props.pages.map((_, index) => { return ( 
          <li className={"page-item" + (this.state.page === (index + 1) ? ' active' : '')} key={index} onClick={() => this.handleNumber(index+1)}><a className="page-link" href='#navigate_questions'>{index+1}</a></li>
      )})}
      <li className={"page-item" + (this.state.page === this.state.max ? ' disabled' : '')} onClick={() => this.handleClick('+') }><a className="page-link" href='#navigate_questions'>Next</a></li>
      <li className={"page-item" + (this.state.page === this.state.max ? ' disabled' : '')} onClick={() => this.handleClick('++') }><a className="page-link" href='#navigate_questions'>Last</a></li>
    </ul>
  </nav>
  <br />
  <div className="row row-cols-1 row-cols-md-2 g-4">
      {this.props.pages[this.state.page - 1].map((item, index) => 
      (<div key={index}>
        <div className="col">
          <div className="card">
            <form action="/data/question" autoComplete="off">
              <input type='hidden' name='id' value={JSON.stringify(item.id)} />
              <input type='hidden' name='operation' value='delete' />
              <input type='submit' name='commit' value='' className='btn-close m-1' />
            </form>
            <div style={{height: '200px', backgroundSize: 'auto 100%', background: item.image, height: '200px'}} className="card-img-top" alt="..." />
            <div className="card-body">
              <h5 className="card-title">{item.question}</h5>
              <p className="card-text">{item.answers[0]}</p>
              {item.types.map((type, index) => <div className='btn btn-success pe-none m-1' key={index}>
                {type.charAt(0).toUpperCase() + type.slice(1)}
              </div>)}
              <p className="card-text"><small className="text-muted">{subjects[item.subject]}</small></p>
            </div>
          </div>
        </div>
        
      </div>)
      )}
    </div>
  </div>
  }
}

if (document.getElementById('navigate_questions') != null) {
  ReactDOM.render(<Question pages={chunkArrayInGroups(questions, 10)} />,
  document.getElementById('navigate_questions'))
}