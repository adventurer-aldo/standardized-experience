import React from 'react'
import ReactDOM from 'react-dom'

class Timer extends React.Component {
    constructor(props) {
        super(props);
        this.state = { time: quiz_timer * 60 }
    }

    tick() {
        this.setState( state=> ({
            time: state.time - 1
        }));
    }

    componentDidMount() {
        this.interval = setInterval(() => this.tick(), 1000);
    }

    componentWillUnmount() {
        clearInterval(this.interval);
    }

    render() {
        <div>:{this.time / 60}:{this.time % 60}</div>
    }

}

if (document.getElementById('timer') != null) {
    ReactDOM.render(<Timer />,document.getElementById('timer'))
};