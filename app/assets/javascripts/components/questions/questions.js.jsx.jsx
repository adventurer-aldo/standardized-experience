class DataQuestions extends React.Component {
  constructor(props) {
    super(props);
    this.state = {page: 0, pages: 0, results: 'Pesquisando', questions: null, editingID: null,
      subjects: [], editingName: '', tagInput: '', tags: [], details: {question: null},
      query: {question: '', level: '', tags: [], parameters: [], questionTypes: '', answer: '', subject: '', order: 'DESC'}, 
      submitData: Array(2).fill({question: '', answer: [''], questionTypes: ['open'], parameters: [],
      tags: [], subject: 0, level: 1, choices: [], tableCoordinates: [[0,0]]})}
    this.updateQuestions = this.updateQuestions.bind(this);
    this.handleChangeNew = this.handleChangeNew.bind(this);
    this.handleDeleteClick = this.handleDeleteClick.bind(this);
    this.handleEditingClick = this.handleEditingClick.bind(this);
    this.handlePageClick = this.handlePageClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleRestoreSearch = this.handleRestoreSearch.bind(this);
    this.handleChangeSearch = this.handleChangeSearch.bind(this);
    this.handleAddElement = this.handleAddElement.bind(this);
    this.handleDeleteElement = this.handleDeleteElement.bind(this);
    this.handleLevelChange = this.handleLevelChange.bind(this);
    this.getMainTypeAffinity = this.getMainTypeAffinity.bind(this);
    this.showButtonGroup = this.showButtonGroup.bind(this);
    this.handleClickButton = this.handleClickButton.bind(this);
    this.handleMatchEqualizer = this.handleMatchEqualizer.bind(this);
    this.fillComplete = this.fillComplete.bind(this);
    this.handleFillAmount = this.handleFillAmount.bind(this);
    this.handleFillEqualizer = this.handleFillEqualizer.bind(this);
    this.handleDeleteRow = this.handleDeleteRow.bind(this);
    this.handleAddRow = this.handleAddRow.bind(this);
    this.handleAddColumn = this.handleAddColumn.bind(this);
    this.handleDeleteColumn = this.handleDeleteColumn.bind(this);
    this.deleteTag = this.deleteTag.bind(this);
    this.handleTagging = this.handleTagging.bind(this);
    this.handleClickParameter = this.handleClickParameter.bind(this);
    this.addTableCoordinate = this.addTableCoordinate.bind(this);
    this.removeTableCoordinate = this.removeTableCoordinate.bind(this);
    this.setDetails = this.setDetails.bind(this);
  }

  // Fetch data from the backend
  updateQuestions(on_page, with_params) {
    let desired_page = (typeof on_page === 'undefined' ? this.state.page : on_page);
    let params = (typeof with_params === 'undefined' ? this.state.query : with_params);
    axios.get(`/api/questions?page=${desired_page}&question=${params.question}&answer=${params.answer}&level=${params.level}&question_types=${params.questionTypes}&tags=${params.tags}&order=${params.order}&subject_id=${params.subject}`)
      .then((response) => {
        this.setState({questions: response.data.questions, page: response.data.page, pages: response.data.pages, results: response.data.results, subjects: response.data.subjects,
        tags: response.data.tags})
      });
  };

  componentDidMount() {
    this.updateQuestions();
  }

  setDetails(id) {
    axios.get(`/api/questions/${id}`)
    .then(response => {
      this.setState({details: {question: response.data.question, answer: response.data.answer, tags: response.data.tags, id: response.data.id, questionTypes: response.data.question_types,
      choices: response.data.choices, parameters: response.data.parameters, image: response.data.image, subject: this.state.subjects.filter(subj => subj[0] == response.data.subject)[0]}})
    })
  }

  // Handle changes to the form that submits/edits a question
  handleChangeNew(e, attribute, index, subIndex) {
    let newValue = e.target.value;
    this.setState(prev => {
      let submitTarget = (prev.editingID === null) ? 1 : 0;
      let newSubmitData = prev.submitData
      if (['answer', 'tags', 'parameters', 'choices'].includes(attribute)) {
        if (typeof subIndex !== 'undefined') {
          ((newSubmitData[submitTarget])[attribute])[index][subIndex] = newValue;
        } else {
          ((newSubmitData[submitTarget])[attribute])[index] = newValue;
        }
      } else {
        (newSubmitData[submitTarget])[attribute] = newValue
      }
      return { submitData: newSubmitData }
    })
  };

  // Handle the deletion of an existing question
  handleDeleteClick(question_id) {
    axios.delete(`/api/questions/${question_id}`,
        {data: {authenticity_token: this.props.auth_token}})
        .then(() => {
          this.updateQuestions();
          if (this.state.editingID === question_id) this.setState({editingID: null});
        });
  };

  getTable(choices, answer) {
    let arr = [];
    choices.forEach((choice, index) => {
      choice.forEach((subChoice, subIndex) => {
        if (subChoice == '') arr.push([index, subIndex]);
      })
    })
    let finalChoices = choices;
    let tempAnswer = answer;
    while (finalChoices.map(row => row.filter(r => r == '').length).filter(m => m !== 0).length > 0) {
      finalChoices.map((choice, index) => {
        if (choice.indexOf('') !== -1) {
          finalChoices[index][choice.indexOf('')] = tempAnswer[0];
          tempAnswer = tempAnswer.slice(1);
        }
      })
    }
    return [arr, finalChoices]
  }

  // Handle the click that sets the form to edit an question rather than make a new one
  handleEditingClick(question_id) {
    if (this.state.editingID === null) {
      var editingQuest = this.state.questions.filter((quest) => {
        return quest.id === question_id;
      })[0]
      axios.get(`/api/questions/${question_id}`)
      .then((response) => {
        let tableStuff = this.getTable(response.data.choices, editingQuest.answer)
        this.setState(prev => {
          return {editingName: editingQuest.question, editingID: editingQuest.id,
          submitData: [{question: editingQuest.question, answer: editingQuest.answer, choices: tableStuff[1],
          level: editingQuest.level, subject: editingQuest.subject, questionTypes: editingQuest.question_types,
          tags: editingQuest.tags, parameters: editingQuest.parameters, tableCoordinates: tableStuff[0]}, prev.submitData[1]]}
        })
        if (typeof document.getElementById('floatingInput') !== 'undefined') document.getElementById('floatingInput').focus();
      })
    } else {
      this.setState({editingID: null});
    }
  };

  // Handles getting data from the server for a clicked page
  handlePageClick(page_number) {
    this.updateQuestions(page_number);
  };

  // Submits data from the form, and the direction it goes depends on whether we're editing
  // or making a new question
  handleSubmit(e, question_id) {
    e.preventDefault();
    let formu = new FormData(e.target);
    if (this.state.editingID === null) {
      axios.post('/api/questions', formu)
          .then(() => this.updateQuestions());
    } else {
      axios.patch(`/api/questions/${question_id}`, formu)
          .then(() => {
            this.updateQuestions();
            this.setState({editingID: null});
          });
    }
    this.setState(prev => {
      return { submitData: [{...prev.submitData[0], question: '', answer: Array(prev.submitData[0].answer.length).fill(''),
      choices: Array(prev.submitData[0].choices.length).fill(prev.submitData[0].questionTypes.includes('table') ? Array(prev.submitData[0].choices[0].length).fill('') : '')}, {...prev.submitData[1], question: '', answer: Array(prev.submitData[1].answer.length).fill(''),
    choices: Array(prev.submitData[1].choices.length).fill(prev.submitData[1].questionTypes.includes('table') ? Array(prev.submitData[1].choices[0].length).fill('') : '')}], editingID: null }
    })
    if (typeof document.getElementById('floatingInput') !== 'undefined') document.getElementById('floatingInput').focus();
  }

  // Handle changes to the search parameters
  handleChangeSearch(e, parameter) {
    let val = e.target.value;
    this.setState(prev => {
      let newQuery = {...prev.query, [parameter]: val}
      this.updateQuestions(0, newQuery);
      return {query: newQuery}
    })
  }

  // Restores the search parameters to none so that all possible questions are shown
  handleRestoreSearch() {
    this.setState(prev => {
      let emptyQuery = {question: '', level: '', tags: [], parameters: [], questionTypes: '', answer: '', subject: '', order: 'DESC'};
      this.updateQuestions(undefined, emptyQuery);
      return {query: emptyQuery}
    })
  }

  // Handles adding answers or choices
  handleAddElement(element) {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target][element].length < 20) {
        if (element == 'choices') {
          newData[target][element].push(['']);
        } else {
          newData[target][element].push('');
        }
      } 
      return {submitData: newData}
    })
  }

  // Handles deleting answers or choices
  handleDeleteElement(element, bad_index) {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      newData[target][element] = newData[target][element].filter((_, index) => index != bad_index )
      return {submitData: newData}
    })
  }

  // Handles level changes
  handleLevelChange(button) {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      newData[target].level += button
      if (newData[target].level == 0) newData[target].level = 4
      if (newData[target].level == 5) newData[target].level = 1
      return {submitData: newData}
    })
  }

  // Determines whether a question type can coexist with another question type
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

  // Shows the color of the question type based on affinity to the main type
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

  // Handles clicking the button to change question types
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
        if (questionType == 'table' && newData[target].tableCoordinates.length < 1) newData[target].tableCoordinates = [[0,0]];
        if ([2,1].includes(this.getMainTypeAffinity(questionType))) {
          newData[target].questionTypes.push(questionType);
        } else {
          newData[target].questionTypes = [questionType]
        }
      }
      // Handle params
      if (newData[target].parameters.includes('order') && !newData[target].questionTypes.includes('caption')) newData[target].parameters = newData[target].parameters.filter(p => p !== 'order')
      if (newData[target].parameters.includes('shuffle') && !(newData[target].questionTypes.includes('table') || newData[target].questionTypes.includes('match'))) newData[target].parameters = newData[target].parameters.filter(p => p !== 'shuffle')
      return {submitData: newData}
    })
  }

  // Ensures there's an equal amount of answers and choices before changing question type to match
  handleMatchEqualizer() {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target].choices.length > newData[target].answer.length) {
        newData[target].choices.splice(newData[target].answer.length)
      } else if (newData[target].choices.length < newData[target].answer.length) {
        let disparity = newData[target].answer.length - newData[target].choices.length;
        newData[target].choices = newData[target].choices.concat(Array(disparity).fill(['']))
      }
      return {submitData: newData}
    })
  }
  
  // Returns a completed string of the fill question type
  fillComplete(paragraph, fillers) {
    let desiredString = paragraph;
    for (let i = 0; i < fillers.length;i++) {
      desiredString = desiredString.replace('%s', `${fillers[i]}`);
    }
    return desiredString
  }
  
  handleFillEqualizer() {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target].choices.length < 1) newData[target].choices = [['']];
      return {submitData: newData}
    })
  }
  // Ensures the number of gaps has an equal number of answers to fill them
  handleFillAmount() {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      let count
      if (newData[target].questionTypes[0] == 'table') {
        count = newData[target].choices.toString()
      } else {
        count = newData[target].choices[0]
      }
      count = count.match(/%s/g) || []
      if (count.length > 20) count = Array(20).fill('');
      let diff = count.length - newData[target].answer.length;
      if (diff < 0) {
        if (count.length < 1) {
          newData[target].answer.splice(count.length + 1)
        } else {
          newData[target].answer.splice(count.length)
        }
      } else if (diff > 0) {
        newData[target].answer = newData[target].answer.concat(Array(diff).fill(''))
      }
      return {submitData: newData}
    })
  }

  handleAddRow() {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target].choices.length < 20) newData[target].choices.push(Array(newData[target].choices[0].length).fill(''));
      return {submitData: newData}
    })
  }
  
  handleDeleteRow() {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target].choices.length > 1) newData[target].choices.splice(newData[target].choices.length - 1);
      return {submitData: newData}
    })
  }

  handleAddColumn() {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target].choices[0].length < 20) newData[target].choices = newData[target].choices.map(choice => choice.concat(''))
      return {submitData: newData}
    })
  }

  handleDeleteColumn() {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target].choices[0].length > 1) {
        newData[target].choices = newData[target].choices.map(choice => {
          let result = choice;
          result.splice(choice.length - 1);
          return result;
        })
      } 
      return {submitData: newData}
    })
  }

  handleTagging(e) {
    let value = e.target.value;
    this.setState((prev) => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      let newInput = prev.tagInput;
      if (value.indexOf(',') !== -1)  {
        if (newData[target].tags.includes(prev.tagInput) || ['',' '].includes(prev.tagInput.trim())) {

        } else {
          newData[target].tags.push(newInput.toLowerCase().trim());
          newInput = ''
        }
      } else {
        newInput = value;
      }
      return {tagInput: newInput, submitData: newData}
    });
  }

  deleteTag(index) {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      newData[target].tags = newData[target].tags.filter((_tag,tag_index) => tag_index !== index)
      return {submitData: newData}
    })
  }

  handleClickParameter(param) {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target].parameters.indexOf(param) == -1) {
        if (param == 'order') {
          if (newData[target].questionTypes.includes('caption')) newData[target].parameters.push(param);
        } else if (param == 'shuffle') {
          if (newData[target].questionTypes.includes('table') || newData[target].questionTypes.includes('match')) newData[target].parameters.push(param);
        } else {
          newData[target].parameters.push(param);
        }
      } else {
        newData[target].parameters = newData[target].parameters.filter(p => p !== param)
      }
      return {submitData: newData}
    })
  }

  addTableCoordinate(coords) {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target].tableCoordinates.length < 20) newData[target].tableCoordinates.push(coords);
      return {submitData: newData}
    })
  }
  
  removeTableCoordinate(coords) {
    this.setState(prev => {
      let target = prev.editingID === null ? 1 : 0;
      let newData = prev.submitData;
      if (newData[target].tableCoordinates.length > 1) newData[target].tableCoordinates = newData[target].tableCoordinates.filter(arr => ([arr[0],arr[1]].toString() !== [coords[0],coords[1]].toString()));
      return {submitData: newData}
    })
  }

  render() {
    return (
    <div>
      <QuestionEditor auth_token={this.props.auth_token} stat={this.props.stat_id} 
      data={this.state.editingID == null ? this.state.submitData[1] : this.state.submitData[0]}
      handleChange={this.handleChangeNew} editing={this.state.editingID}
      handleSubmit={this.handleSubmit} originalName={this.state.editingName}
      handleAddElement={this.handleAddElement} handleDeleteElement={this.handleDeleteElement}
      subjects={this.state.subjects} showButtonGroup={this.showButtonGroup} getAffinity={this.getMainTypeAffinity}
      handleLevelChange={this.handleLevelChange} handleClickButton={this.handleClickButton}
      handleMatchEqualizer={this.handleMatchEqualizer} fillComplete={this.fillComplete}
      handleFillAmount={this.handleFillAmount} handleFillEqualizer={this.handleFillEqualizer}
      handleAddRow={this.handleAddRow} handleDeleteRow={this.handleDeleteRow}
      handleAddColumn={this.handleAddColumn} handleDeleteColumn={this.handleDeleteColumn}
      tableCoordinates={this.state.tableCoordinates} handleDeleteTag={this.deleteTag}
      handleTagging={this.handleTagging} tagInput={this.state.tagInput} tags={this.state.tags}
      handleClickParameter={this.handleClickParameter} addTableCoordinate={this.addTableCoordinate}
      removeTableCoordinate={this.removeTableCoordinate}
      /><div className="h4 pb-2 my-2 border-bottom border-dark" >Minhas questões</div>
      <PaginationQuestion key={0} page={this.state.page} pages={this.state.pages} handleClick={this.handlePageClick}
      query={this.state.query} handleChange={this.handleChangeSearch} handleRestore={this.handleRestoreSearch} subjects={this.state.subjects} />
      <QuestionDetails details={this.state.details} getTable={this.getTable} fillComplete={this.fillComplete} />
      <div className="border-bottom border-dark text-end" >{this.state.results} resultado{this.state.results == 1 ? '' : 's'}</div>
      <QuestionNavigator auth_token={this.props.auth_token} questions={this.state.questions} editing={this.state.editingID}
      subjects={this.state.subjects} handleDelete={this.handleDeleteClick} handleEditing={this.handleEditingClick} 
      setDetails={this.setDetails} />
      <PaginationQuestion key={1} page={this.state.page} pages={this.state.pages} handleClick={this.handlePageClick}
      query={this.state.query} handleChange={this.handleChangeSearch} handleRestore={this.handleRestoreSearch} subjects={this.state.subjects} />
    </div>
    )
  }
}