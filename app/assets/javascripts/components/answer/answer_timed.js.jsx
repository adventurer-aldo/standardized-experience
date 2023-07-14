class AnswerTimed extends React.Component {
  constructor(props) {
    super()
    this.state = {progress: 0, answers: [], time: props.timeLimit - 1}
    this.addAnswer = this.addAnswer.bind(this)
  }

  componentDidMount() {
    setInterval(() => {
      this.setState(prev => {
        return {time: prev.time - 1}
      })
    }, 1000)
  }

  addAnswer(id, answer) {
    if (this.state.progress == this.props.answers.length) return;
    this.setState(prev => {
      let newAnswers = prev.answers
      let newProgress = prev.progress
      let newTime = prev.time
      newAnswers.push({id: id, answer: answer})
      if (newProgress + 1 >= this.props.answers.length) {
        //
      } else {
        newProgress++
        newTime = this.props.timeLimit
      }
      return {answers: newAnswers, progress: newProgress, time: newTime}
    })
  }

  getProgressColor() {
    if (this.state.time > this.props.timeLimit / 2) {
      return 'success'
    } else if (this.state.time > this.props.timeLimit / 3) {
      return 'warning'
    } else {
      return 'danger'
    }
  }

  render() {
    return (
      <div className="border rounded overflow-hidden w-100 my-2">
        <div className="progress" style={{height: 20, borderRadius: 0}}>
          <div className={`progress-bar progress-bar-striped progress-bar-animated bg-${this.getProgressColor()}`} 
          style={{width: `${this.state.time / this.props.timeLimit * 100}%`}}>
          </div>
        </div>
        <div className="d-flex">
          {this.state.answers.map((answers, index) => <div key={index}>
            {answers.answer.map((answer, index) => <input key={index} type='hidden' name={`answer[${answers.id}][]`} value={answer} />)}
          </div>)}
          <span className="d-inline-block p-2 fw-bold text-bg-dark">{this.state.progress + 1}. </span>
          <Answer id={this.props.answers[this.state.progress].id} question={this.props.answers[this.state.progress].question}
          question_type={this.props.answers[this.state.progress].question_type}
          answers_size={this.props.answers[this.state.progress].answers_size}
          choices={this.props.answers[this.state.progress].choices}
          last={this.props.answers.length - 1 == this.state.progress}
          onProceed={this.addAnswer} time={this.state.time} image={this.props.answers[this.state.progress].image}
          showProceed={this.state.progress < this.props.answers.length - 1}/>
        </div>
      </div>
    )
  }
}