class AnswerTimed extends React.Component {
  constructor(props) {
    super()
    this.state = {progress: 0, answers: []}
    this.addAnswer = this.addAnswer.bind(this)
  }

  addAnswer(id, answer) {
    this.setState(prev => {
      let newAnswers = prev.answers
      let newProgress = prev.progress
      newAnswers.push({id: id, answer: answer})
      if (newProgress + 1 >= this.props.answers.length) {
        /* Do stuff */
      } else {
        newProgress++
      }
      return {answers: newAnswers, progress: newProgress}
    })
  }

  render() {
    return (
      <div className="d-flex border rounded overflow-hidden w-100 my-2">
        {this.state.answers.map((answers, index) => <div key={index}>
          {answers.answer.map((answer, index) => <input key={index} type='hidden' name={`answer[${answers.id}][]`} value={answer} />)}
        </div>)}
        <span className="d-inline-block p-2 fw-bold text-bg-dark">{this.state.progress + 1}. </span>
        <Answer id={this.props.answers[this.state.progress].id} question={this.props.answers[this.state.progress].question}
        question_type={this.props.answers[this.state.progress].question_type}
        answers_size={this.props.answers[this.state.progress].answers_size}
        choices={this.props.answers[this.state.progress].choices}
        onProceed={this.addAnswer}
        showProceed={this.state.progress < this.props.answers.length - 1}/>
      </div>
    )
  }
}