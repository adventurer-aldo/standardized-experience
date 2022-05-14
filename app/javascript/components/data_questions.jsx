import React from 'react'
import ReactDOM from 'react-dom'

class Question extends React.Component {

  render() { return <div>
    <p>Hi. My name is lil' Jordan. I need more than a week to rest from everything that's happening.<br />
    I long for the one day where I have the day completely empty, devoid of any future tasks, one that I could
    even complete Emalia. Sigh. Guess my About Me wasn't lying about tired being my eternal mood.
    </p>
  </div>
  }
}


if (document.getElementById('navigate_questions') != null) {
  ReactDOM.render(<Question />, document.getElementById('navigate_questions'))
}