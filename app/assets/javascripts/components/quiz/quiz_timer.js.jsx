class QuizTimer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      timeLeft: (this.props.endTime - (new Date().getTime())) / 1000 
    }
  }

  componentDidMount() {
    const timerInterval = setInterval(() => {
      let remainingTime = (this.props.endTime - (new Date().getTime())) / 1000 ;
      this.setState({
        timeLeft: remainingTime
      })
      if (Math.trunc(remainingTime / 60) === 2 && Math.trunc(remainingTime % 60) == 30) {
        document.getElementById('timing-bar').style = 'top: 0px;'
        // if (typeof this.props.fire !== 'undefined' && this.props.fire !== '') {
          // let bgmElement = document.getElementById('bgm');
          // bgmElement.src = this.props.fire;
          // bgmElement.load();
        // }
      }
      if (remainingTime < 0 || document.getElementById('submitBtn').disabled) {
        clearInterval(timerInterval);
        if (remainingTime < 0) {
          this.setState({timeLeft: 0});
          document.getElementById('quiz').submit();
        }
      }
    },1000)
  }


  render() {
    return (
    <QuizTimerDIsplay minutes={Math.trunc(this.state.timeLeft / 60).toLocaleString(
      'en-US', 
      {minimumIntegerDigits: 2, 
      useGrouping:false})} seconds={
        Math.trunc(this.state.timeLeft % 60).toLocaleString(
          'en-US', 
          {minimumIntegerDigits: 2, 
          useGrouping:false})
        } />)
  }
}