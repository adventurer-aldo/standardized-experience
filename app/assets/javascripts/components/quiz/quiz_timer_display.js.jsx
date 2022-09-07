class QuizTimerDIsplay extends React.Component {
  render() {
    return (<div>{this.props.minutes}:{this.props.seconds}</div>)
  }
}