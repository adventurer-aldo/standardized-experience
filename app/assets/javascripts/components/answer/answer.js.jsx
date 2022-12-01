const abecedary = "abcdefghijklmnopqrstuvwxyz"

function Answer(props) {
  const [answers, setAnswers] = React.useState([]);

  React.useEffect(() => {
    if (props.time == 0) {
      props.onProceed(props.id, answers);
    }
  }, [props.time]);

  const manipulateSelectable = (choice) => {
    let newAnswers = answers;
    if (newAnswers.includes(choice)) {
      newAnswers = newAnswers.filter((answer) => answer != choice);
    } else {
      if (props.question_type == 'choice' && props.answers_size < 2) {
        newAnswers = [choice];
      } else {
        newAnswers.push(choice);
      }
    };
    setAnswers(newAnswers);
  };

  const getSolver = () => {
    if (props.question_type == 'choice') {
      return (
        props.choices.map((choice, index) => <span key={index}>
          <input type={props.answers_size < 2 ? 'radio' : "checkbox"} value={choice}
          id={`${props.id}|${choice}`} name={`answer[${props.id}][]`} checked={answers.includes(choice)}
          className={`btn-check`} onChange={() => {manipulateSelectable(choice)}} />
          <label htmlFor={`${props.id}|${choice}`} className={`btn btn-${answers.includes(choice) ? 'primary' : 'light'} border m-1`}>
            <b>{abecedary[index]})&ensp;</b>{choice}
          </label>
        </span>)
      );
    };
  };

  return (
    <div className="d-block p-1 w-100">
      {props.question.split(/\n/).map((line, index) => <div key={index}>{line}</div>)}
      <div>{getSolver()}</div>
      <div className="w-100 text-end">
        {props.showProceed == true ? <button type="button" className="btn btn-primary w-100"
        onClick={() => props.onProceed(props.id, answers)}>
          Proceed
        </button> : ''}
      </div>
    </div>
  )
}

class Answered extends React.Component {

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

  timeAdvance() {
    if (this.props.time <= 0) {
      this.props.onProceed(this.props.id, this.state.answers)
    }
  }

  render() {
    this.timeAdvance()
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