import React from 'react'
import ReactDOM from 'react-dom'

class Timer extends React.Component {
    constructor(props) {
        super(props);
        this.state = { time: ((quiz_timer) * 60) }
    }

    tick() {
        if (this.state.time < 1) {
            this.setState( state=> ({
                time: "Time's up!"
            }));
            clearInterval(this.interval);
            document.getElementById("quiz").submit()
        } else {
            this.setState( state=> ({
                time: state.time - 1
            }));
            if (this.state.time == 2*60) {
                document.getElementById('navbar').style = 'display: block'
                var ost = document.getElementById('bgm')
                ost.src=fire;
                ost.load();
            };
        }
    }

    componentDidMount() {
        this.interval = setInterval(() => this.tick(), 1000);
    }

    componentWillUnmount() {
        clearInterval(this.interval);
    }
    

    render() { return <div>
        {(Math.trunc(this.state.time / 60)
        ).toLocaleString(
            'en-US', 
            {minimumIntegerDigits: 2, 
            useGrouping:false})}:{(this.state.time % 60).toLocaleString('en-US', {minimumIntegerDigits: 2, useGrouping:false})}
        </div>

    }

}

if (document.getElementById('timer') != null) {
    ReactDOM.render(<Timer />,document.getElementById('timer'))
};