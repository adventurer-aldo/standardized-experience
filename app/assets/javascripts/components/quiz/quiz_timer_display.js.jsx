class QuizTimerDIsplay extends React.Component {
  render() {
    return (<div className={this.props.minutes == 0 ? 'blink-text' : ''}>{this.props.minutes}:{this.props.seconds}</div>)
  }
}