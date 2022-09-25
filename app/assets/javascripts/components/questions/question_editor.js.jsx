function QuestionEditor(props) {  
  const returnInterface = () => {
    if (props.data.questionTypes.filter((questionType) => ['open','caption','formula','choice','veracity'].includes(questionType)).length > 0) {
      return (
      <div>
        {/* Answers */}
        <div className="d-flex mt-1">
          <div className="w-100">
            {props.data.answer.map((answer, index) => (
            <div key={index} className="form-floating d-flex">
              <input type="text" className="rounded-0 rounded-start form-control" id={`floatingAnswer${index}`}
              placeholder="Resposta" name="question[answer][]" required="required"
              value={answer} onChange={(event) => props.handleChange(event, `answer`, index)}/>
              <label htmlFor={`floatingAnswer${index}`}>
                {props.editing === null ? `Resposta${props.data.choices.length > 0 ? ' Verdadeira' : ''} ${props.data.answer.length > 1 ? index + 1 : ''}` : `Nova resposta${props.data.choices.length > 0 ? ' verdadeira' : ''} ${props.data.answer.length > 1 ? index + 1 : ''}`}
              </label>
              {props.data.answer.length > 1 ? (
                <button tabIndex='-1' type="button" className="btn btn-danger border-top border-bottom rounded-0" onClick={() => props.handleDeleteElement('answer', index)}>
                  <i className="bi-dash fs-3 align-middle" />
                </button>
              ) : ''}
            </div>
            ))}
          </div>
          <button tabIndex='-1' type="button" className="btn border-bottom btn-primary rounded-0 rounded-end" onClick={() => props.handleAddElement('answer')}>
            <i className="bi-plus fs-3 align-middle" />
          </button>
        </div>
        {/* Choices */}
        {props.data.questionTypes.filter((questionType) => ['choice','veracity'].includes(questionType)).length > 0 ? (
        <div className="d-flex mt-1">
          <div className={props.data.choices.length > 0 ? 'w-100' : ''}>
            {props.data.choices.map((choices, index) => (
            <div key={index} className="form-floating d-flex">
              <input type="text" className="rounded-0 rounded-start form-control" id={`floatingAnswer${index}`}
              placeholder="Pergunta" name={`question[choices][${index}][texts][]`} required="required"
              value={choices[0]} onChange={(event) => props.handleChange(event, `choices`, index, 0)}/>
              <label htmlFor={`floatingAnswer${index}`}>
                {props.editing === null ? `Resposta Falsa ${props.data.choices.length > 1 ? index + 1 : ''}` : `Nova resposta falsa ${props.data.choices.length > 1 ? index + 1 : ''}`}
              </label>
              <button tabIndex='-1' type="button" className="btn btn-danger border-bottom rounded-0" onClick={() => props.handleDeleteElement('choices', index)}>
                <i className="bi-dash fs-3 align-middle" />
              </button>
            </div>
            ))}
          </div>
          <button tabIndex='-1' type="button" className={`${props.data.choices.length > 0 ? '' : 'w-100'} ${props.data.choices.length > 0 ? 'rounded-0 rounded-end' : ''} btn border-top border-bottom btn-primary`} onClick={() => props.handleAddElement('choices')}>
            <i className="bi-plus fs-3 align-middle" />{props.data.choices.length > 0 ? '' : <span className="align-middle">Resposta Falsa</span>}
          </button>
        </div>
        ) : ''}
      </div>
      )
    } else if (props.data.questionTypes.filter((questionType) => ['match'].includes(questionType)).length > 0) {
      // When the Question Type is Match
      return (
        <div className="mt-1">
          <div className="d-flex">
            <div className="w-100">
              {props.data.answer.map((answer, index) => <div key={index}>
                <div key={index} className="d-flex w-100">
                  <div className="form-floating w-50">
                    <input type="text" className="rounded-0 rounded-start form-control" id={`floatingAnswer${index}`}
                    placeholder="Chave" name="question[answer][]" required="required"
                    value={answer} onChange={(event) => props.handleChange(event, `answer`, index)}/>
                    <label htmlFor={`floatingAnswer${index}`}>
                      {props.editing === null ? `Chave ${props.data.answer.length > 1 ? index + 1 : ''}` : `Nova chave ${props.data.answer.length > 1 ? index + 1 : ''}`}
                    </label>
                  </div>
                  <button disabled={props.data.answer.length < 2} tabIndex='-1' type="button" className="btn btn-danger border-top border-bottom rounded-0" onClick={() => {props.handleDeleteElement('answer', index);props.handleDeleteElement('choices', index)}}>
                    <i className="bi-dash fs-3 align-middle" />
                  </button>
                  <div className="form-floating w-50">
                    <input type="text" className="rounded-0 form-control" id={`floatingChoice${index}`}
                    placeholder="Valor" name={`question[choices][${index}][texts][]`} required="required"
                    value={props.data.choices[index][0]} onChange={(event) => props.handleChange(event, `choices`, index, 0)}/>
                    <label htmlFor={`floatingChoice${index}`}>
                      {props.editing === null ? `Valor ${props.data.choices.length > 1 ? index + 1 : ''}` : `Novo valor ${props.data.answer.length > 1 ? index + 1 : ''}`}
                    </label>
                  </div>
                </div>
              </div>)}
            </div>
            <button type="button" className={`${props.data.choices.length > 0 ? '' : 'w-100'} ${props.data.choices.length > 0 ? 'rounded-0 rounded-end' : ''} btn border-top border-bottom btn-primary`} onClick={() => {props.handleAddElement('choices'); props.handleAddElement('answer')}}>
              <i className="bi-plus fs-3 align-middle" />{props.data.choices.length > 0 ? '' : <span className="align-middle">Resposta Falsa</span>}
            </button>
          </div>
        </div>
      )
    } else if (props.data.questionTypes.filter((questionType) => ['fill'].includes(questionType)).length > 0) {
      // When the QuestionType is Fill
      return (
      <div><strong>Texto:</strong> <span className="text">{props.fillComplete(props.data.choices[0][0], props.data.answer)}</span>
        <div className="form-floating">
          <textarea id="Sentence" className="form-control" required={true} type="text" name="question[choices][0][texts][]" 
          value={props.data.choices[0][0]} onChange={(event) => {props.handleChange(event, 'choices', 0, 0);props.handleFillAmount()}} style={{minHeight: 50}} />
          <label htmlFor="Sentence">Parágrafo. Use %s para adicionar lacunas.</label>
        </div>
          {props.data.answer.map((answer, index) => (
          <div key={index} className="form-floating d-flex">
            <input type="text" className="rounded-0 rounded-start form-control" id={`floatingAnswer${index}`}
            placeholder="Resposta" name="question[answer][]" required={true}
            value={answer} onChange={(event) => props.handleChange(event, `answer`, index)}/>
            <label htmlFor={`floatingAnswer${index}`}>
              {props.editing === null ? `Lacuna ${props.data.answer.length > 1 ? index + 1 : ''}` : `Nova lacuna ${props.data.answer.length > 1 ? index + 1 : ''}`}
            </label>
          </div>
          ))}
      </div>
      )
    } else if (props.data.questionTypes.filter((questionType) => ['table'].includes(questionType)).length > 0) {
      // When the Question Type is Table
      return (
      <div>
        <strong>Tabela:</strong> <span className="text-muted fs-7">(Pressione as celas para transformá-las em lacunas.)</span>
      <div className="d-flex mb-1">
        <div className="w-100 overflow-scroll">
          {props.data.choices.map((row, index) => (
          <div key={index} className="d-flex">
            {row.map((_cell, rIndex) => props.data.tableCoordinates.filter(arr => arr[0] == index && arr[1] == rIndex).length > 0 ? (
              <button key={rIndex} type="button" className="btn btn-primary rounded-0 w-100"
              onClick={() => props.removeTableCoordinate([index, rIndex])}>
                {index + 1}-{rIndex + 1}
              </button>
              ) : (
              <button key={rIndex} type="button" className="btn btn-secondary rounded-0 w-100" 
              onClick={() => props.addTableCoordinate([index, rIndex])}>
                {index + 1}-{rIndex + 1}
              </button>
              )
            )}
          </div>
        ))}
        </div><div className="d-flex flex-column">
        <div style={{borderTopRightRadius: '0.375rem', borderBottomRightRadius: '0.375rem'}} className="rounded-0 px-3 bg-dark text-dark h-100">/</div>
        </div>
      </div>
      <div className="d-flex">
        <div className="w-100">{props.data.choices.map((row, index) => (
          <div key={index} className="d-flex overflow-scroll w-100">{row.map((_cell, rIndex) => (
            <div key={rIndex} className="w-100">{props.data.tableCoordinates.filter(arr => arr[0] == index && arr[1] == rIndex).length > 0 ? (
              <div>
              <input type='hidden' name={`question[choices][${index}][texts][]`} value="" />
              <input required={true} placeholder="Lacuna" className="form-control w-100 rounded-0 text-bg-info" 
              name="question[answer][]" value={props.data.choices[index][rIndex]}
              onChange={(event) => {props.handleChange(event, 'choices', index, rIndex);props.handleFillAmount()}}
              /></div>
            ) : <input required={true} placeholder="Cela" className="form-control w-100 rounded-0" name={`question[choices][${index}][texts][]`}
            onChange={(event) => {props.handleChange(event, 'choices', index, rIndex);props.handleFillAmount()}} value={props.data.choices[index][rIndex]}
            />}</div>))}
          </div>))}
        </div>
        <div className="d-flex flex-column"><button onClick={props.handleAddColumn} type="button" style={{borderTopRightRadius: '0.375rem', borderTopLeftRadius: '0', borderBottomLeftRadius: '0', borderBottomRightRadius: '0'}} className="btn btn-primary h-100">+</button><br/><button onClick={props.handleDeleteColumn} type="button" disabled={props.data.choices[0].length < 2} className="btn btn-danger h-100 rounded-0">-</button></div>
      </div>
      <div className="d-flex"><button type="button" onClick={props.handleAddRow} className="btn btn-primary w-100" style={{borderTopRightRadius: '0', borderTopLeftRadius: '0', borderBottomLeftRadius: '0.375rem', borderBottomRightRadius: '0'}}>Adicionar Linha</button><button type="button" onClick={props.handleDeleteRow} className="btn btn-danger w-100" style={{borderTopRightRadius: '0', borderTopLeftRadius: '0', borderBottomLeftRadius: '0', borderBottomRightRadius: '0.375rem'}} disabled={props.data.choices.length < 2}>Remover Linha</button></div>

      </div>)
    } else {
      return <div>--UNRECOGNIZED QUESTION TYPE--</div>
    }
  }

  return (
  <form autoComplete="off" encType="multipart/form-data" acceptCharset="UTF-8" onSubmit={(event) => props.handleSubmit(event, props.editing)}>
    <input type='hidden' name='authenticity_token' value={props.auth_token} />
    <input type='hidden' name='question[stat_id]' value={props.stat} />
    <div className="form-floating mt-1 d-flex ">
     <input type="text" className="rounded-0 rounded-start form-control" id="floatingInput" 
     placeholder="Pergunta" name="question[question]" required="required"
     value={props.data.question} onChange={(event) => props.handleChange(event, 'question')}/>
     <label htmlFor="floatingInput">
        {props.editing === null ? 'Qual será a pergunta?' : `Modificar a pergunta "${props.originalName}" para o quê?`}
      </label>
      <button tabIndex='-1' type="button" className="btn btn-primary rounded-0 rounded-end"
      data-bs-toggle="modal" data-bs-target="#questionImage">
        <i className="bi-image fs-3 align-middle" />
      </button>
    </div>
    <div className="modal fade" id="questionImage" tabIndex="-1" aria-labelledby="questionImageLabel" aria-hidden="true">
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title" id="questionImageLabel">Anexar imagem</h5>
            <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div className="modal-body">
          <input className="form-control mb-1" type="file" id="image"/>
            <div className="form-check form-switch">
              <input className="form-check-input" type="checkbox" role="switch" id="usePreviousImage" />
              <label className="form-check-label" htmlFor="usePreviousImage">Usar da questão anterior</label>
            </div>
            <div className="d-flex"><span className="p-2" style={{whiteSpace: 'nowrap'}}>Especificar ID:</span><input className="form-control" type='number' /></div>
            <span className="text-muted">Permite especificar a ID da questão anterior que se deseja usar. Deve ter "Usar questão anterior" ativo.</span>
          </div>
          <div className="modal-footer">
            <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
            <button type="button" className="btn btn-danger">Apagar imagem</button>
          </div>
        </div>
      </div>
    </div>
    {returnInterface()}
    <div className="overflow-scroll p-1 text-center">
      <div className="btn-group" role="group" aria-label="Basic checkbox toggle button group">
        <button tabIndex='-1' className={`btn btn-${props.showButtonGroup('open')}`} type="button"
        onClick={() => props.handleClickButton('open')}>Aberta</button>

        <button tabIndex='-1' className={`btn btn-${props.showButtonGroup('caption')}`} type="button"
        onClick={() => props.handleClickButton('caption')}>Listar</button>
        
        <button tabIndex='-1' className={`btn btn-${props.showButtonGroup('formula')}`} type="button"
        onClick={() => props.handleClickButton('formula')}>Fórmula</button>

        <button tabIndex='-1' className={`btn btn-${props.showButtonGroup('choice')}`} type="button"
        onClick={() => props.handleClickButton('choice')}>Escolha</button>

        <button tabIndex='-1' className={`btn btn-${props.showButtonGroup('veracity')}`} type="button"
        onClick={() => props.handleClickButton('veracity')}>Veracidade</button>

        <button tabIndex='-1' className={`btn btn-${props.showButtonGroup('match')}`} type="button"
        onClick={() => {props.handleMatchEqualizer();props.handleClickButton('match')}}>Correspondência</button>

        <button tabIndex='-1' className={`btn btn-${props.showButtonGroup('fill')}`} type="button"
        onClick={() => {props.handleFillEqualizer();props.handleClickButton('fill')}}>Preencher</button>

        <button tabIndex='-1' className={`btn btn-${props.showButtonGroup('table')}`} type="button"
        onClick={() => {props.handleFillEqualizer();props.handleClickButton('table')}}>Tabela</button>

        <div className="bg-light" style={{width: 3}}></div>

        <button tabIndex='-1' className={`btn btn-${props.data.parameters.includes('strict') ? 'info' : 'secondary'}`}
        type="button" onClick={() => props.handleClickParameter('strict')}>Rigoroso</button>

        <button tabIndex='-1' type="button" onClick={() => props.handleClickParameter('order')}
        className={`btn btn-${props.data.parameters.includes('order') ? 'info' : (props.data.questionTypes.includes('caption') ? 'secondary' : 'dark')}`}>
          Ordenado</button>

        <button tabIndex='-1' type="button" onClick={() => props.handleClickParameter('shuffle')}
        className={`btn btn-${props.data.parameters.includes('shuffle') ? 'info' : ((props.data.questionTypes.includes('table') || props.data.questionTypes.includes('match')) ? 'secondary' : 'dark')}`}>
          Baralhar</button>
      </div>
    </div>
    {props.data.questionTypes.map(type => <input key={type} type='hidden' name="question[question_types][]" value={type} />)}
    {props.data.parameters.map(parameter => <input key={parameter} type='hidden' name="question[parameters][]" value={parameter} />)}
    {props.data.tags.map((tag, index) => <div key={index} className="d-inline-block btn btn-secondary me-1 mb-1"><input type='hidden' name="question[tags][]" value={tag} />{tag}<button className="align-middle btn-close" onClick={() => props.handleDeleteTag(index)} type="button"></button></div>)}
    <input placeholder="Insira os temas da questão" list="existingTags" type='text' onChange={(event) => props.handleTagging(event)} className="form-control" name="tag" value={props.tagInput} />
    <datalist id="existingTags">
        {props.tags.map((tag) => <option key={tag} value={tag} />)}
    </datalist>
    <div className="d-flex my-1">
      <div className="form-floating w-100">
        <select id="floatingSubject" className="form-select form-select h-100 rounded-0 rounded-start" 
        aria-label=".form-select example"  name='question[subject_id]' value={props.data.subject}
        onChange={(event) => props.handleChange(event, 'subject')}>
        {props.subjects.map((subject) => <option key={subject[0]} value={subject[0]}>{subject[1]}</option>)}
        </select>
        <label htmlFor="floatingSubject">Para que cadeira?</label>
      </div>
      <input type='hidden' name='question[level]' value={props.data.level} />
      <div id="carouselExampleControls" className="carousel carousel-fade slide w-25 text-center text-bg-primary p-2 fw-bold rounded-end">
        <div className="carousel-inner fs-4">
          <div className={`carousel-item ${props.data.level == 1 ? 'active' : ''}`}>
            1º Teste
          </div>
          <div className={`carousel-item ${props.data.level == 2 ? 'active' : ''}`}>
            2º Teste
          </div>
          <div className={`carousel-item ${props.data.level == 3 ? 'active' : ''}`}>
            Trabalho
          </div>
          <div className={`carousel-item ${props.data.level == 4 ? 'active' : ''}`}>
            Exame
          </div>
        </div>
        <button tabIndex='-1' className="carousel-control-prev" type="button" onClick={() => props.handleLevelChange(-1)}
        data-bs-target="#carouselExampleControls">
          <span className="carousel-control-prev-icon" aria-hidden="true"></span>
          <span className="visually-hidden">Previous</span>
        </button>
        <button tabIndex='-1' className="carousel-control-next" type="button" onClick={() => props.handleLevelChange(1)} 
        data-bs-target="#carouselExampleControls">
          <span className="carousel-control-next-icon" aria-hidden="true"></span>
          <span className="visually-hidden">Next</span>
        </button>
      </div>
    </div>
    <div className="d-grid mt-1">
      <button type="submit" className={`btn btn-${props.editing == null ? 'primary' : 'warning'}`}>{props.editing == null ? 'Criar Nova Questão' : 'Editar Questão'}</button>
    </div>
  </form>
  )
}