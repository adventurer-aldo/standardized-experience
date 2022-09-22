function LessonSolver(props) {
  if (props.point.question_type == 'open') {
    return <input className="form-control" placeholder="Resposta" 
    value={props.point.attempt[0]} onChange={(event) => props.handleChange(event, 0)} />
  } else if (props.point.question_type == 'caption') {
    return <div>
      {props.point.answers.map((answer, index) => <input className="form-control mb-1" 
      placeholder={"Resposta" + (index + 1)} key={index}
      value={props.point.attempt[0]} onChange={(event) => props.handleChange(event, index)} />)}
      
    </div> 
  } else if (props.point.question_type == 'choice') {
    return <div>HOY</div>
  } else {
    return <div>SMTH</div>
  }
}