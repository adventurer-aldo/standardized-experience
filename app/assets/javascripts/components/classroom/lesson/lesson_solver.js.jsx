function LessonSolver(props) {
  if (props.point.question_type == 'caption' || props.point.question_type == 'open') {
    return <div>
      {props.attempts.map((answer, index) => <input className="form-control mb-1" 
      placeholder={"Resposta" + (index + 1)} key={index}
      value={props.point.attempt[0]} onChange={(event) => props.handleChange(event, index)} />)}
      
    </div> 
  } else if (props.point.question_type == 'choice') {
    return <div>{props.alternatives.map((alternative, index) => <button key={index} className="btn btn-light">
      {alternative}
      </button>)}</div>
  } else {
    return <div>SMTH</div>
  }
}