const abecedary = "abcdefghijklmnopqrstuvwxyz"

class Answer extends React.Component {

  constructor(props) {
    super();
    this.state = {answers: []};
    this.manipulateSelectable = this.manipulateSelectable.bind(this);
  }

  manipulateSelectable(choice) {
    let newAnswers = this.state.answers
    if (newAnswers.includes(choice)) {
      newAnswers = newAnswers.filter((answer) => answer != choice)
    } else {
      if (this.props.question_type == 'choice' && this.props.answers_size < 2) {
        newAnswers = [choice]
      } else {
        newAnswers.push(choice)
      }
    }
    this.setState({answers: newAnswers})
  }

  getSolver() {
    if (this.props.question_type == 'choice') {
      return (
        this.props.choices.map((choice, index) => <span key={index}>
          <input type={this.props.answers_size < 2 ? 'radio' : "checkbox"} value={choice}
          id={`${this.props.id}|${choice}`} name={`answer[${this.props.id}][]`} checked={this.state.answers.includes(choice)}
          className={`btn-check`} onChange={() => {this.manipulateSelectable(choice)}} />
          <label htmlFor={`${this.props.id}|${choice}`} className={`btn btn-${this.state.answers.includes(choice) ? 'primary' : 'light'} border m-1`}>
            <b>{abecedary[index]})&ensp;</b>{choice}
          </label>
        </span>)
      )
    }
  }

  render() {
    let re = <br/>;
    return (
      <div className="d-block p-1 w-100">
        {this.props.question.split(/\n/).map((line, index) => <div key={index}>{line}</div>)}
        <div>{this.getSolver()}</div>
        <div className="w-100 text-end">
          {this.props.showProceed == true ? <button type="button" className="btn btn-primary w-100"
          onClick={() => this.props.onProceed(this.props.id, this.state.answers)}>
            Proceed
          </button> : ''}
        </div>
      </div>
    )
  }
}