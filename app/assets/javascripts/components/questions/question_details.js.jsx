function QuestionDetails(props) {
  const displayAnswer = (questionTypes) => {
    if (questionTypes.includes('table')) {
      return (
        <div>
          {props.getTable(props.details.choices, props.details.answer)[1].map((row, index) => <div key={index} className="d-flex w-100">{row.map((cell, rIndex) => <div key={rIndex} className="form-control w-100 rounded-0">{cell}</div>)}</div>)}
        </div>
      )
    } else if (questionTypes.includes('match')) {
      return (
        <div>
          {props.details.answer.map((ans, index) => <div key={index} className="d-flex w-100">
            <div className="w-50 form-control rounded-0 rounded-start">{ans}</div>
            <div className="text-bg-secondary border-bottom border-dark"><i className="bi-play-fill p-2 align-middle fs-4"></i></div>
            <div className="w-50 form-control rounded-0 rounded-end">{props.details.choices[index]}</div>
          </div>)}
        </div>
      ) 
    } else if (questionTypes.includes('fill')) {
      return (
        <div>{props.fillComplete(props.details.choices[0][0], props.details.answer)}</div>
      )
    } else {
      return (
        <div>
          <em>Respostas{props.details.choices.length > 0 ? ' Verdadeiras' : ''}</em>
          {props.details.answer.map((answer, index) => <div key={index} className="form-control">{answer}</div>)}

          {props.details.choices.length > 0 ? <div>
            <em>Respostas Falsas</em>
            {props.details.choices.map((choice, rIndex) => <div key={rIndex} className="form-control">{choice[0]}</div>)}
          </div> : ''}          
        </div>
      )
    }
  }

  if (props.details.question == null) {
    return (
      <div className="modal fade" id="questionDetails" tabIndex="-1" aria-labelledby="questionDetailsLabel" aria-hidden="true">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <h5 className="modal-title" id="questionDetailsLabel">ID: 0</h5>
              <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div className="modal-body">
              ...
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
            </div>
          </div>
        </div>
      </div>
    )
  } else {
    return (
      <div className="modal fade" id="questionDetails" tabIndex="-1" aria-labelledby="questionDetailsLabel" aria-hidden="true">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <h5 className="modal-title" id="questionDetailsLabel">ID: {props.details.id}</h5>
              <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div className="modal-body">
              <strong>{props.details.question}</strong><br/>
              {displayAnswer(props.details.questionTypes)}
              {props.details.questionTypes.map((questionType, index) => <span key={index} className={`mx-1 badge bg-${index == 0 ? 'success' : 'warning'}`}>
                {['Aberta','Listar','Fórmula','Escolha','Veracidade','Correspondência','Preencher','Tabela'][['open','caption','formula','choice','veracity','match','fill','table'].findIndex((og) => og == questionType)]}
              </span>)} {props.details.parameters.map((param, index) => <span key={index} className={`mx-1 badge bg-info`}>
                {['Rigoroso','Ordenado','Baralhar'][['strict','order','shuffle'].findIndex((og) => og == param)]}
              </span>)}
              <br/><strong>Cadeira: </strong>{props.details.subject[1]}
              <br/><strong>Temas: </strong> {props.details.tags.map(tag => <div key={tag} className="btn btn-secondary">{tag}</div>)}
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
            </div>
          </div>
        </div>
      </div>
    )
  }
}