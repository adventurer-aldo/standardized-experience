class DataQuestions extends React.Component {
  constructor(props) {
    super(props);
    this.state = {page: 0, pages: 0, results: 'Pesquisando', questions: null, editingID: null,
      subjects: [], editingName: '',
      query: {question: '', level: 1, tags: [], parameters: [], questionTypes: [], answers: [''], subject: '', order: 'ASC'}, 
      submitData: Array(2).fill({question: '', answer: [''], questionTypes: ['open'], parameters: [],
      tags: [], level: 1, choices: []})}
    this.updateQuestions = this.updateQuestions.bind(this);
    this.handleChangeNew = this.handleChangeNew.bind(this);
    this.handleDeleteClick = this.handleDeleteClick.bind(this);
    this.handleEditingClick = this.handleEditingClick.bind(this);
    this.handlePageClick = this.handlePageClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleRestoreSearch = this.handleRestoreSearch.bind(this);
    this.handleChangeSearch = this.handleChangeSearch.bind(this);
    this.handleAddAnswer = this.handleAddAnswer.bind(this);
    this.handleDeleteAnswer = this.handleDeleteAnswer.bind(this);
    this.handleLevelChange = this.handleLevelChange.bind(this);
    this.getMainTypeAffinity = this.getMainTypeAffinity.bind(this);
    this.showButtonGroup = this.showButtonGroup.bind(this);
    this.handleClickButton = this.handleClickButton.bind(this);
  }

  updateQuestions(on_page, with_params) {
    let desired_page = (typeof on_page === 'undefined' ? this.state.page : on_page);
    let params = (typeof with_params === 'undefined' ? this.state.query : with_params);
    axios.get(`/api/questions?page=${desired_page}&question=${params.question}&answer=${params.answer}&level=${params.level}&question_types=${params.questionTypes}&tags=${params.tags}&order=${params.order}&subject_id=${params.subject}`)
      .then((response) => {
        this.setState({questions: response.data.questions, page: response.data.page, pages: response.data.pages, results: response.data.results, subjects: response.data.subjects})
      });
  };

  componentDidMount() {
    this.updateQuestions();
  }

  handleChangeNew(e, attribute, index) {
    let newValue = e.target.value;
    this.setState(prev => {
      let submitTarget = prev.editingID === null ? 1 : 0;
      let newSubmitData = prev.submitData
      if (['answer', 'tags', 'parameters'].includes(attribute)) {
        ((newSubmitData[submitTarget])[attribute])[index] = newValue;
      } else {
        (newSubmitData[submitTarget])[attribute] = newValue
      }
      return { submitData: newSubmitData }
    })
  };

  handleDeleteClick(question_id) {
    axios.delete(`/api/questions/${question_id}`,
        {data: {authenticity_token: props.auth_token}})
        .then(() => {
          updateQuestions();
          if (editingID === question_id) setEditingID(null);
        });
  };

  handleEditingClick(question_id) {
    if (editingID === null) {
      var editingSubj = subjects.filter((subj) => {
        return subj.id === question_id;
      })[0]
      setEditingName(editingSubj.title);
      setSubmitData((prev) => [{title: editingSubj.title,
        description: (editingSubj.description === null ? '' : editingSubj.description), visibility: editingSubj.visibility,
        formula: editingSubj.formula, job_type: editingSubj.job_type, practical: editingSubj.practical}, prev[1]]);
      setEditingID(subject_id);
      if (typeof document.getElementById('floatingInput') !== 'undefined') window.location.hash = '#floatingInput';
    } else {
      setEditingID(null);
    }
  };

  handlePageClick(page_number) {
    updateQuestions(page_number);
  };

  handleSubmit(e, question_id) {
    e.preventDefault();
    if (editingID === null) {
      let formu = submitData[1];
      formu.authenticity_token = props.auth_token;
      formu.stat_id = props.stat;
      axios.post('/api/questions', formu)
          .then(() => updateQuestions());
    } else {
      let formu = submitData[0];
      formu.authenticity_token = props.auth_token;
      formu.stat_id = props.stat;
      axios.patch(`/api/questions/${question_id}`, submitData[0])
          .then(() => {
            updateQuestions();
            setEditingID(null);
          });
    }
    setSubmitData(Array(2).fill({title: '', description: '', formula: 0, job_type: 0,
      practical: 0, visibility: '0'}))
  }

  handleChangeSearch(e, parameter) {
    let newQuery = {...query, [parameter]: e.target.value};
    setQuery(newQuery);
    updateQuestions(0, newQuery);
  }

  handleRestoreSearch() {
    let emptyQuery = {title: '', description: '', formula: '', job_type: '', practical: '', order: 'ASC'};
    setQuery(emptyQuery);
    updateQuestions(undefined, emptyQuery);
  }

  handleAddAnswer() {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      newData[target].answer.push('');
      return {submitData: newData}
    })
  }

  handleDeleteAnswer(bad_index) {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      newData[target].answer = newData[target].answer.filter((_answer, index) => index != bad_index )
      return {submitData: newData}
    })
  }

  handleLevelChange(button) {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      newData[target].level += button
      if (newData[target].level == 0) newData[target].level = 4
      if (newData[target].level == 5) newData[target].level = 1
      console.log(newData[target].level);
      return {submitData: newData}
    })
  }

  getMainTypeAffinity(questionType) {
    let matchGroups = [['open', 'choice'], ['caption', 'choice', 'veracity'], ['formula'], ['match'], ['fill'], ['table']];
    let questionTypes = (this.state.editingID == null ? this.state.submitData[1] : this.state.submitData[0]).questionTypes
    if (questionTypes[0] == questionType) {
      return 2
    } else {
        let firstFilter = matchGroups.filter(group => group.includes(questionTypes[0]));
        if (questionTypes.length > 1) {
          if (firstFilter.filter(group => group.includes(questionTypes[1])).filter(group => group.includes(questionType)).length > 0) {
            return 1
          } else {
            return 0
          }
        } else {
          if (firstFilter.filter(group => group.includes(questionType)).length > 0) {
            return 1
          } else {
            return 0
          }
        }
    }
  }

  showButtonGroup(questionType) {
    let selectedTypes = (this.state.editingID == null ? this.state.submitData[1] : this.state.submitData[0]).questionTypes
    if (this.getMainTypeAffinity(questionType) == 2) {
      return 'success'
    } else if (this.getMainTypeAffinity(questionType) == 1 && selectedTypes.includes(questionType)) {
      return 'warning'
    } else if (this.getMainTypeAffinity(questionType) == 1 && !selectedTypes.includes(questionType)) {
      return 'secondary'
    } else {
      return 'dark'
    }
  }

  handleClickButton(questionType) {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target].questionTypes.includes(questionType) && this.getMainTypeAffinity(questionType) == 2 && newData[target].questionTypes.length > 1) {
        // Type is selected and is main and is not only type
        newData[target].questionTypes = newData[target].questionTypes.filter(type => type !== questionType)
      } else if (newData[target].questionTypes.includes(questionType) && this.getMainTypeAffinity(questionType) == 1) {
        // Type is selected and is secondary type
        newData[target].questionTypes = newData[target].questionTypes.filter(type => type !== questionType)
      } else if (newData[target].questionTypes.includes(questionType) && this.getMainTypeAffinity(questionType) == 2 && newData[target].questionTypes.length == 1) {
        // Type is selected and is main and is only type
      } else {
        if (this.getMainTypeAffinity(questionType) == 2) {
          newData[target].questionTypes.push(questionType);
        } else if (this.getMainTypeAffinity(questionType) == 1) {
          newData[target].questionTypes.push(questionType);
        } else {
          newData[target].questionTypes = [questionType]
        }
      }
      return {submitData: newData}
    })
  }

  render() {
    return (
    <div>
      <QuestionEditor auth_token={this.props.auth_token} stat={this.props.stat} 
      data={this.state.editingID == null ? this.state.submitData[1] : this.state.submitData[0]}
      handleChange={this.handleChangeNew} editing={this.state.editingID}
      handleAddAnswer={this.handleAddAnswer} handleDeleteAnswer={this.handleDeleteAnswer}
      subjects={this.state.subjects} showButtonGroup={this.showButtonGroup}
      handleLevelChange={this.handleLevelChange} handleClickButton={this.handleClickButton}
      />
      <PaginationQuestion />
      <QuestionNavigator auth_token={this.props.auth_token} />
    </div>
    )
  }
}