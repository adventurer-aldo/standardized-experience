function FocusSubject(props) {
  
  return <div className="btn-group my-2">
    <button
      type="button"
      className={`btn btn-${[0, 1].includes(props.subject.evaluable_focus) ? 'primary' : 'secondary'}`}
      onClick={() => props.setFocus(1, props.subject.evaluable_id)}
    >
      1st Test
    </button>
    <button
      type="button"
      className={`btn btn-${[0, 2].includes(props.subject.evaluable_focus) ? 'primary' : 'secondary'}`}
      onClick={() => props.setFocus(2, props.subject.evaluable_id)}
    >
      2nd Test
    </button>
    <button
      type="button"
      className={`btn btn-${[0, 4].includes(props.subject.evaluable_focus) ? 'primary' : 'secondary'}`}
      onClick={() => props.setFocus(4, props.subject.evaluable_id)}
    >
      Exam
    </button>
  </div>
}