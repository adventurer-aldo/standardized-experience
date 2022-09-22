class QuestionNavigator extends React.Component {
  render() {
    if (this.props.questions === null) {
      return <div className="d-flex justify-content-center">
      <div className="spinner-border text-primary" role="status" style={{width: '6rem', height: '6rem'}}>
        <span className="visually-hidden">Loading...</span>
      </div>
    </div>
    } else {
      return <div className="row row-cols-1 row-cols-md-2 g-4">{this.props.questions.map((question) => (
        <div key={question.id} className="col">
        <div className="modal fade" id={`deleteModal${question.id}`} tabIndex="-1" aria-labelledby={`deleteModalLabel${question.id}`} aria-hidden="true">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title" id={`deleteModalLabel${question.id}`}>Apagar questão</h5>
                <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div className="modal-body">
                Tem certeza de que pretende apagar a seguinte pergunta?<br/><span className="fw-bold">{question.question}</span>?<br/><br/>
                Esta ação é irreversível! Se bem que pode simplesmente refazê-la de algum jeito...
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">Não...</button>
                <button type="button" data-bs-dismiss="modal" className="btn btn-danger" onClick={() => this.props.handleDelete(question.id)}>Certeza!</button>
              </div>
            </div>
          </div>
        </div>
          <div className="card">
            <div className="card-header">
              <div className="d-flex">
                  <button type="button" className={`btn btn-${this.props.editing === question.id ? 'warning' : 'secondary'}`} onClick={() => this.props.handleEditing(question.id)}>Editar</button>
                  <button type="button" data-bs-toggle="modal" data-bs-target={`#deleteModal${question.id}`} className="btn btn-danger mx-1">Apagar</button>
                  <button type="button" data-bs-toggle="modal" data-bs-target="#questionDetails" onClick={() => this.props.setDetails(question.id)} className="btn btn-primary">Detalhes</button>
                  <button type="button"  className="btn btn-outline-primary ms-auto" disabled={true}>{['1º Teste','2º Teste','Trabalho','Exame'][question.level - 1]}</button>
              </div>
            </div>
            <div className="card-body">
              <div className="card-text d-inline-block text-truncate w-100 fw-bold">{question.question}</div>
              <p className="text-truncate w-100">{question.answer}</p>
              <p className="card-text text-truncate w-100"><small className="text-muted">{this.props.subjects[this.props.subjects.findIndex((subj) => subj[0] == question.subject )][1]}</small></p>
              {question.question_types.map((questionType, index) => <span key={index} className={`mx-1 badge bg-${index == 0 ? 'success' : 'warning'}`}>
                {['Aberta','Listar','Fórmula','Escolha','Veracidade','Correspondência','Preencher','Tabela'][['open','caption','formula','choice','veracity','match','fill','table'].findIndex((og) => og == questionType)]}
              </span>)}
            </div>
          </div>
        </div>
      ))}</div>
    }
  }
}