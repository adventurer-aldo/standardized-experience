function SelectClass(props) {
  [selectedSubject, setSelectedSubject] = React.useState(0);
  [tags, setTags] = React.useState([]);

  const handleSubjectClick = (subject_id) => {
    axios.get(`/api/questions?subject_id=${subject_id}&order=ASC&level=&question_types=`)
    .then(response => {
      setTags(response.data.tags);
      setSelectedSubject(subject_id);
    })
  }

  const handleTagClick = (tag) => {
    axios.post('/api/lessons', {lesson: {tag: tag, subject_id: selectedSubject}, authenticity_token: props.auth_token})
    .then(response => {
      window.location = '/lesson/' + response.data.id
    })
  }

  return (
    <div>
      <div id="list-example" className="list-group">
        {props.subjects.map((subject, index) => (
          <button key={index} onClick={() => handleSubjectClick(subject.id)} className={`list-group-item list-group-item-action ${selectedSubject == subject.id ? 'active' : ''}`} >{subject.title}</button>
          ))}
      </div>
      <div className="mt-2">
        {tags.map((tag, index) => <button onClick={() => handleTagClick(tag)} className="btn btn-warning p-2 rounded m-1" key={index}>{tag}</button>)}
      </div>
    </div>
  )
}