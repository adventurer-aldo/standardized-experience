import React from 'react';
import ReactDOM from 'react-dom';

// Create a Classroom component
// This component will take a props object with the following properties:
//   - title: string
//   - questions: array of objects
//   - time: number of minutes
// The questions array will contain objects with the following properties:
//  - text: string
// - answers: array of strings
// - completed: boolean
// This component will render a rectangular div with the following structure:
// The title property rendered in a h1 element at the top of the component
// The time property rendered in a h2 element at the top of the component, with it counting down
// When it reaches 0, the quiz will end and the user will be redirected to the results page, and the form will be submitted
// In the center of the component, the first question will be rendered, with two buttons on each side:
//  - one to go to the previous question, which will be disabled if there is no previous question
//  - one to go to the next question, which will be disabled if there is no next question
// Below the buttons, a progress bar will be rendered, with the current question number and the total number of questions
// The progress bar will be updated depending on how many questions have the completed property set to true
// Below the question is an input field, with the placeholder "Informação que satisfaz a pergunta."
// If the character that the user types does not have a corresponding index in the first answer in the answers array, delete the character
// When the input matches the first answer in the answers array, the completed property of the question will be set to true
// When the completed property of the question is set to true, the next question will be rendered and the progress bar will be updated
// Questions with completed set to true can no longer be shown
// When all questions are completed or the time is up, the user will be redirected to the results page, and the form will be submitted


class QuizLesson extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      currentQuestion: 0,
      time: this.props.time,
      timeLeft: this.props.time,
      interval: null,
      questions: this.props.questions,
      answers: [],
      completed: false,
      image: {}
    };
  }

  componentDidMount() {
    this.setState({
      interval: setInterval(() => {
        this.setState({
          timeLeft: this.state.timeLeft - 1
        });
        if (this.state.timeLeft === 0) {
          this.setState({
            completed: true
          });
          clearInterval(this.state.interval);
        }
      }, 1000)
    });
  }

  componentWillUnmount() {
    clearInterval(this.state.interval);
  }

  onClick = (index) => {
    let questions = this.state.questions;
    if (index === 0) {
      questions[index].completed = true;
    } else {
      questions[index].completed = true;
      questions[index - 1].completed = true;
    }
    this.setState({
      questions: questions
    });
  }

  onChange = (event) => {
    let questions = this.state.questions;
    let answers = this.state.answers;
    let index = event.target.name.split('[')[1].split(']')[0];
    let value = event.target.value;
    if (value.length > 0) {
      if (answers[index] === undefined) {
        answers[index] = [];
      }
      answers[index].push(value);
    } else {
      answers[index].pop();
    }
    if (answers[index].length > 0) {
      questions[index].completed = true;
    }
    this.setState({
      questions: questions,
      answers: answers
    });
  }

  render() {
    let questions = this.state.questions;
    let answers = this.state.answers;
    let currentQuestion = questions[this.state.currentQuestion];
    let previousQuestion = questions[this.state.currentQuestion - 1];
    let nextQuestion = questions[this.state.currentQuestion + 1];
    let progress = this.state.currentQuestion + 1;
    let total = questions.length;
    let timeLeft = this.state.timeLeft;
    let completed = this.state.completed;
    let image = this.state.image;
    let time = this.props.time;
    let title = this.props.title;
    let imageUrl = this.props.imageUrl;
    let imageAlt = this.props.imageAlt;
    let imageWidth = this.props.imageWidth;
    let imageHeight = this.props.imageHeight;
    let imageStyle = {
      width: imageWidth,
      height: imageHeight
    };
    let imageClass = "";
    if (imageUrl) {
      imageClass = "image";
    }
    return (
      <div className="quiz-lesson">
        <div className="header">
          <h1>{title}</h1>
          <h2>{timeLeft}</h2>
        </div>
        <div className="content">
          <div className="image-container">
            <div className={imageClass} style={imageStyle}>
              <img src={imageUrl} alt={imageAlt} />
            </div>
          </div>
          <div className="question-container">
            <div className="question">
              <h3>{currentQuestion.text}</h3>
            </div>
            <div className="answers">
              <div className="answer">
                <button
                  className="previous"
                  onClick={() => {
                    if (previousQuestion) {
                      this.setState({
                        currentQuestion: this.state.currentQuestion - 1
                      });
                    }
                  }}
                  disabled={!previousQuestion}
                >
                  <i className="fas fa-arrow-left"></i>
                </button>
              </div>
              <div className="answer">
                <button
                  className="next"
                  onClick={() => {
                    if (nextQuestion) {
                      this.setState({
                        currentQuestion: this.state.currentQuestion + 1
                      });
                    }
                  }}
                  disabled={!nextQuestion}
                >
                  <i className="fas fa-arrow-right"></i>
                </button>
              </div>
              <div className="progress">
                <div className="progress-bar">
                  <div className="progress-bar-progress" style={{width: `${progress * 100 / total}%`}}></div>
                </div>
                <div className="progress-text">
                  {progress}/{total}
                </div>
              </div>
              <div className="answer">
                <input
                  type="text"
                  name={`answers[${this.state.currentQuestion}]`}
                  placeholder="Informação que satisfaz a pergunta."
                  onChange={this.onChange}
                />
              </div>
            </div>
          </div>
        </div>
        <div className="footer">
          <button
            className="submit"
            onClick={() => {
              this.setState({
                completed: true
              });
              clearInterval(this.state.interval);
            }}
            disabled={completed}
          >
            Enviar
          </button>
        </div>
      </div>
    );
  }
}

document.addEventListener('turbo:load', () => {
// Render the QuizLesson component in the div with the id "classroom"
if (document.getElementById('classroom')) {
  ReactDOM.render(
    <QuizLesson
      title="Quiz"
      time={60}
      questions={[
        {
          text: "Qual o nome do seu melhor amigo?",
          answers: ["João", "Pedro", "Paulo", "José"],
          completed: false
        },
        {
          text: "Qual o nome do seu melhor amigo?",
          answers: ["João", "Pedro", "Paulo", "José"],
          completed: false
        },
        {
          text: "Qual o nome do seu melhor amigo?",
          answers: ["João", "Pedro", "Paulo", "José"],
          completed: false
        }
      ]}
      imageUrl="https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"
      imageAlt="Imagem de um cachorro"
      imageWidth="800"
      imageHeight="600"
    />,
    document.getElementById("classroom")
  );
}});