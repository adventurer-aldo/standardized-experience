function TagsSubjects(props) {

  if (props.subject.evaluable_tags != null) {
    return <div>{props.subject.tags.map((tag, index) => <button key={index} onClick={() => {props.sendTag(tag, props.subject.evaluable_id)}}
    className={`btn btn-${props.subject.evaluable_tags.length == 0 || props.subject.evaluable_tags.includes(tag) ? "warning" : "secondary"} me-1 mb-1`}>{tag}</button>)}</div>
  } else {
    return <div></div>
  }
}