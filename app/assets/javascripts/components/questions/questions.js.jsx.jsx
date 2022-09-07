class Questions extends React.Component {
  constructor(props) {
    super(props);
    this.status = {page: 1, questions: null}
  }

  componentDidMount() {
    axios.get('/api/questions')
  }

  render() {
    return (
    <div>
      <QuestionEditor />
      <QuestionNavigator />
    </div>
    )
  }
}