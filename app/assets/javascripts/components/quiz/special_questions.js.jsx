class QuestionMatch extends React.Component {
  constructor(props) {
    super(props);
    this.state = {answers: this.props.answers};
    this.swap = this.swap.bind(this);
  }

  swap(index, direction) {
    this.setState(prev => {
      let placeholder_a = prev.answers[index];
      let placeholder_b = prev.answers[index + direction];
      let fullstack = prev.answers;

      fullstack[index + direction] = placeholder_a;
      fullstack[index] = placeholder_b;
      return {answers: fullstack};
    })
  }

  render() {
    return ( 
      <div className="border border-muted rounded">
        {this.props.choices.map((choice, index) => <div key={index} className="d-flex w-100 border border-muted">
          <div className="w-100 d-flex align-items-center">
            <span className="p-2">{this.state.answers[index]}</span>
          </div>
          <input type='hidden' name={`answer[${this.props.id}][]`} value={this.state.answers[index]} />
          <div className="d-flex flex-column">
            <button type="button" style={{fontSize: 10}} disabled={index == 0} onClick={() => this.swap(index, -1)}
            className="btn btn-dark fw-bold rounded-0 border-0 border-bottom border-light border-2">
              <i className="bi bi-arrow-up"></i>
            </button>
            <button type="button" className="btn btn-dark fw-bold rounded-0" onClick={() => this.swap(index, 1)}
            disabled={index == this.props.choices.length - 1} style={{fontSize: 10}}>
              <i className="bi bi-arrow-down"></i>
            </button>
          </div>
          <div className="w-100 d-flex align-items-center justify-content-end">
            <span className="p-2">{choice}</span>
          </div>
        </div>)}
      </div>
    )
  } 
}