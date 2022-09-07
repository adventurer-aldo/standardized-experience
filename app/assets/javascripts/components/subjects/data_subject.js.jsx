function DataSubject(props) {
  [subjects, setSubjects] = React.useState(null);
  [editingID, setEditingID] = React.useState(null);
  [evaluables, setEvaluables] = React.useState([]);
  [search, setSearch] = React.useState('');
  [page, setPage] = React.useState(0);
  [pages, setPages] = React.useState(0);
  [submitData, setSubmitData] = React.useState(Array(2).fill({title: '', description: '',
  formula: 0, job_type: 0, practical: 0, description: '', visibility: '0'}));

  React.useEffect(() => {
    updateSubjects();
  },[]);
  
  const updateSubjects = (on_page, query) => {
    desired_page = (typeof on_page === 'undefined' ? page : on_page);
    desired_title = (typeof query === 'undefined' ? search : query)
    axios.get('/api/stats')
    .then((response) => {
      setEvaluables(response.data.evaluables);
      axios.get(`/api/subjects?page=${desired_page}&title=${desired_title}`)
      .then((response) => {
        setSubjects(response.data.subjects);
        setPage(response.data.page);
        setPages(response.data.pages);
      });
    });
  };

  const handleEvaluateClick = (subject_id) => {
    var newEvaluables = evaluables.includes(subject_id) ? evaluables.filter((evaluable) => {
      return evaluable !== subject_id
    }) : evaluables.concat(subject_id);
    if (newEvaluables.length > 6) newEvaluables = newEvaluables.slice(1);
    axios.patch(`/api/stats/${props.stat}`, 
    {authenticity_token: props.auth_token,
      stat: {evaluables: newEvaluables}
    }).then(() => {
      updateSubjects();
    });
  };

  const handleChangeNew = (e, attribute) => {
    let newValue = e.target.value;
    if (editingID === null) {
      setSubmitData(prevData => {
        return [prevData[0], {...prevData[1], [attribute]: newValue}]
      })
    } else {
      setSubmitData(prevData => {
        return [{...prevData[0], [attribute]: newValue}, prevData[1]]
      })
    };
  };

  const handleDeleteClick = (subject_id) => {
    axios.delete(`/api/subjects/${subject_id}`, 
    {data: {authenticity_token: props.auth_token}})
    .then(() => {
      updateSubjects();
      if (editingID === subject_id) setEditingID(null);
    });
  };

  const handleEditingClick = (subject_id) => {
    if (editingID === null) {
      var editingSubj = subjects.filter((subj) => {
        return subj.id === subject_id;
      })[0]
      setSubmitData((prev) => [{title: editingSubj.title, 
      description: (editingSubj.description === null ? '' : editingSubj.description), visibility: editingSubj.visibility,
      formula: editingSubj.formula, job_type: editingSubj.job_type, practical: editingSubj.practical}, prev[1]]);
      setEditingID(subject_id);
      if (typeof document.getElementById('floatingInput') !== 'undefined') window.location.hash = '#floatingInput';
    } else {
      setEditingID(null);
    };
  };

  const handlePageClick = (page_number) => {
    console.log("Alright, I'm gonna go get a page!");
    console.log(`I know you picked ${page_number}, don't need to yell at me...Yeesh.`)
    updateSubjects(page_number);
  };

  const handleSubmit = (e, subject_id) => {
    e.preventDefault();
    if (editingID === null) {
      let formu = submitData[1];
      formu.authenticity_token = props.auth_token;
      formu.stat_id = props.stat;
      axios.post('/api/subjects', formu)
      .then(() => updateSubjects());
    } else {
      let formu = submitData[0];
      formu.authenticity_token = props.auth_token;
      formu.stat_id = props.stat;
      axios.patch(`/api/subjects/${subject_id}`, submitData[0])
      .then(() => {
        updateSubjects();
        setEditingID(null);
      });
    }
    setSubmitData(Array(2).fill({title: '', description: '', formula: 0, job_type: 0,
    practical: 0, visibility: '0'}))
  }

  const handleChangeSearch = (e) => {
    setSearch(e.target.value);
    updateSubjects(undefined, e.target.value);
  }

  return <div className="w-100">
    <NewSubject 
    handleSubmit={handleSubmit} formulas={props.formulas} editing={editingID}
    originalName={editingID === null ? '' : subjects.filter((subj) => subj.id == editingID)[0].title}
    data={editingID === null ? submitData[1] : submitData[0]} auth_token={props.auth_token}
    handleChange={handleChangeNew} evaluables={evaluables} stat={props.stat}
    />
    <div className="h4 pb-2 my-2 border-bottom border-dark" >Cadeiras disponíveis</div>
    <PaginationSubject 
    page={page} pages={pages} handleClick={handlePageClick} search={search}
    handleChange={handleChangeSearch} />
    <div className="row row-cols-1 row-cols-md-2 g-4 mt-1">
      <SubjectList 
      subjects={subjects} editing={editingID} handleEvaluate={handleEvaluateClick}
      handleDelete={handleDeleteClick} handleEditing={handleEditingClick}
      formulas={props.formulas} auth_token={props.auth_token} evaluables={evaluables}
      stat={props.stat} />
    </div>
    </div>
}