function DataSubject(props) {
  [subjects, setSubjects] = React.useState(null);
  [editingID, setEditingID] = React.useState(null);
  [editingName, setEditingName] = React.useState('');
  [evaluables, setEvaluables] = React.useState([]);
  [query, setQuery] = React.useState({title: '', description: '', formula: '', job_type: '', practical: '', order: 'ASC'});
  [page, setPage] = React.useState(0);
  [pages, setPages] = React.useState(0);
  [results, setResults] = React.useState('Pesquisando');
  [submitData, setSubmitData] = React.useState(Array(2).fill({title: '', description: '',
  formula: 0, job_type: 0, practical: 0, visibility: '0', allow_foreign: '1'}));

  React.useEffect(() => {
    updateSubjects();
  },[]);
  
  const updateSubjects = (on_page, with_params) => {
    let desired_page = (typeof on_page === 'undefined' ? page : on_page);
    let params = (typeof with_params === 'undefined' ? query : with_params);
    axios.get('/api/stats')
    .then((response) => {
      setEvaluables(response.data.evaluables);
      axios.get(`/api/subjects?page=${desired_page}&title=${params.title}&description=${params.description}&job_type=${params.job_type}&practical=${params.practical}&formula=${params.formula}&order=${params.order}`)
      .then((response) => {
        setSubjects(response.data.subjects);
        setPage(response.data.page);
        setPages(response.data.pages);
        setResults(response.data.results);
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
      setEditingName(editingSubj.title);
      console.log(editingSubj.title);
      setSubmitData((prev) => [{title: editingSubj.title, 
      description: (editingSubj.description === null ? '' : editingSubj.description), visibility: editingSubj.visibility, allow_foreign: editingSubj.allow_foreign,
      formula: editingSubj.formula, job_type: editingSubj.job_type, practical: editingSubj.practical}, prev[1]]);
      setEditingID(subject_id);
      if (typeof document.getElementById('floatingInput') !== 'undefined') document.getElementById('floatingInput').focus();
    } else {
      setEditingID(null);
    }
  };

  const handlePageClick = (page_number) => {
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
      axios.patch(`/api/subjects/${subject_id}`, formu)
      .then(() => {
        updateSubjects();
        setEditingID(null);
      });
    }
    setSubmitData(Array(2).fill({title: '', description: '', formula: 0, job_type: 0,
    practical: 0, visibility: '0', allow_foreign: '1'}))
  }

  const handleChangeSearch = (e, parameter) => {
    let newQuery = {...query, [parameter]: e.target.value};
    setQuery(newQuery);
    updateSubjects(0, newQuery);
  }

  const handleRestoreSearch = () => {
    let emptyQuery = {title: '', description: '', formula: '', job_type: '', practical: '', order: 'ASC'};
    setQuery(emptyQuery);
    updateSubjects(undefined, emptyQuery);
  }

  return (
    <div className="w-100">
      <NewSubject
      handleSubmit={handleSubmit} formulas={props.formulas} editing={editingID}
      originalName={editingName}
      data={editingID === null ? submitData[1] : submitData[0]} auth_token={props.auth_token}
      handleChange={handleChangeNew} evaluables={evaluables} stat={props.stat}
      />
      <div className="h4 pb-2 my-2 border-bottom border-dark" >Cadeiras disponíveis</div>
      <PaginationSubject key={0}
          page={page} pages={pages} handleClick={handlePageClick} query={query} handleRestore={handleRestoreSearch}
          handleChange={handleChangeSearch} formulas={props.formulas}/>
      <div className="border-bottom border-dark text-end" >{results} resultado{results == 1 ? '' : 's'}</div>
      <div className="row row-cols-1 row-cols-md-2 g-4 mt-1 justify-content-center">
        <SubjectList
        subjects={subjects} editing={editingID} handleEvaluate={handleEvaluateClick}
        handleDelete={handleDeleteClick} handleEditing={handleEditingClick}
        formulas={props.formulas} auth_token={props.auth_token} evaluables={evaluables}
        stat={props.stat} />
      </div>
      <PaginationSubject key={1}
          page={page} pages={pages} handleClick={handlePageClick} query={query} handleRestore={handleRestoreSearch}
          handleChange={handleChangeSearch} formulas={props.formulas}/>
    </div>
  )
}