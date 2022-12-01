const journey_stages = ['', 'First evaluations', 'Second evaluations', 'Repositions',
'Course works', 'Regular Exams', 'Recurrence Exams',
'Results']

class Journey extends React.Component {
  constructor(props) {
    super()
    this.consumer = createConsumer('/cable');
    this.state = { progress: 0, level: props.level, cheer: props.cheer };
    this.handleClick = this.handleClick.bind(this);
    this.reloadJourneyElements = this.reloadJourneyElements.bind(this);
  }

  componentDidMount() {
    this.createSubscription(this.props.id)
  }

  createSubscription(journey_id) {
    let reloadJourneyElements = this.reloadJourneyElements
    this.consumer.subscriptions.create( { channel: 'JourneyChannel', id: journey_id }, {
      initialized() {
        console.log("Hello World")
      },

      received(data) {
        console.log("Received!")
        reloadJourneyElements(data.level, data.cheer)
      }
    })
  }

  reloadJourneyElements(level, cheer) {
    this.setState({level: level, cheer: cheer})
    axios.get('/')
    .then(response => {
      let parser = new DOMParser();
      let newDoc = parser.parseFromString(response.data, 'text/html');
      let bgmElement = document.getElementById('bgm');
      if (bgmElement.src !== newDoc.getElementById('bgm').src) {
        bgmElement.src = newDoc.getElementById('bgm').src;
        bgmElement.load()
      };
      ['journey'].forEach((element) => {
        document.getElementById(element).innerHTML = newDoc.getElementById(element).innerHTML;
      })
    })
  }

  handleClick() {
    if (this.state.level === 7) {
      axios.post('/api/journeys', {authenticity_token: this.props.csrf_token})
      .then(response => this.createSubscription(response.data.id))
    }
  }

  render() {
    return (
      <div className={`text-start border rounded p-1 my-1 w-100 ${this.state.level === 7 ? 'btn btn-primary' : ''}`}
      onClick={this.handleClick}>
        <h5 className={`border-bottom border-${this.state.level === 7 ? 'light' : 'dark'} p-1`}><span id="journey-level" className="fw-bold">{journey_stages[this.state.level]}</span></h5>
        <span id="journey-cheer">{this.state.cheer} {this.state.level === 7 ? "Your journey is over. Click here to start a new one, whenever you're ready!" : ''}</span>
      </div>
    )
  }
}