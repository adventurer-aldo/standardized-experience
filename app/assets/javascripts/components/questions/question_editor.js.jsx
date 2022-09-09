function QuestionEditor(props) {

  return (
  <form autoComplete="off" encType="multipart/form-data" acceptCharset="UTF-8">
    <input type='hidden' name='authenticity_token' value={props.auth_token} />
    <input type='hidden' name='stat_id' value={props.stat} />
    <div className="form-floating mt-1 d-flex ">
     <input type="text" className="rounded-0 rounded-start form-control" id="floatingInput" 
     placeholder="Pergunta" name="question[question]" required="required"
     value={props.data.question} onChange={(event) => props.handleChange(event, 'question')}/>
     <label htmlFor="floatingInput">
        {props.editing === null ? 'Qual será a pergunta?' : `Modificar a pergunta "${props.originalName}" para o quê?`}
      </label>
      <button type="button" className="btn btn-primary rounded-0 rounded-end">
        <i className="bi-image fs-3 align-middle" />
      </button>
    </div>
    <div className="d-flex mt-1">
      <div className="w-100">
        {props.data.answer.map((answer, index) => (
        <div key={index} className="form-floating d-flex">
          <input type="text" className="rounded-0 rounded-start form-control" id={`floatingAnswer${index}`}
          placeholder="Pergunta" name="question[answer]" required="required"
          value={answer} onChange={(event) => props.handleChange(event, `answer`, index)}/>
          <label htmlFor={`floatingAnswer${index}`}>
            {props.editing === null ? `Resposta ${props.data.answer.length > 1 ? index + 1 : ''}` : `Nova resposta ${props.data.answer.length > 1 ? index + 1 : ''}`}
          </label>
          {props.data.answer.length > 1 ? (
            <button type="button" className="btn btn-danger border-top border-bottom rounded-0" onClick={() => props.handleDeleteAnswer(index)}>
              <i className="bi-dash fs-3 align-middle" />
            </button>
          ) : ''}
        </div>
        ))}
      </div>
      <button type="button" className="btn border-top border-bottom btn-primary rounded-0 rounded-end" onClick={props.handleAddAnswer}>
        <i className="bi-plus fs-3 align-middle" />
      </button>
    </div>
    <div className="overflow-scroll p-1 text-center">
      <div className="btn-group" role="group" aria-label="Basic checkbox toggle button group">
        <button className={`btn btn-${props.showButtonGroup('open')}`} type="button"
        onClick={() => props.handleClickButton('open')}>Aberta</button>

        <button className={`btn btn-${props.showButtonGroup('caption')}`} type="button"
        onClick={() => props.handleClickButton('caption')}>Listar</button>
        
        <button className={`btn btn-${props.showButtonGroup('formula')}`} type="button"
        onClick={() => props.handleClickButton('formula')}>Fórmula</button>

        <button className={`btn btn-${props.showButtonGroup('choice')}`} type="button"
        onClick={() => props.handleClickButton('choice')}>Escolha</button>

        <button className={`btn btn-${props.showButtonGroup('veracity')}`} type="button"
        onClick={() => props.handleClickButton('veracity')}>Veracidade</button>

        <button className={`btn btn-${props.showButtonGroup('match')}`} type="button"
        onClick={() => props.handleClickButton('match')}>Correspondência</button>

        <button className={`btn btn-${props.showButtonGroup('fill')}`} type="button"
        onClick={() => props.handleClickButton('fill')}>Preencher</button>

        <button className={`btn btn-${props.showButtonGroup('table')}`} type="button"
        onClick={() => props.handleClickButton('table')}>Tabela</button>
      </div>
    </div>
    <div className="d-flex mt-1">
      <div className="form-floating w-100">
        <select id="floatingSubject" className="form-select form-select rounded-0 rounded-start" 
        aria-label=".form-select example"  name='question[subject]' value={props.data.subject}
        onChange={(event) => props.handleChange(event, 'subject')}>
        {props.subjects.map((subject) => <option key={subject[0]} value={subject[0]}>{subject[1]}</option>)}
        </select>
        <label htmlFor="floatingSubject">Para que cadeira?</label>
      </div>
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
        <button className="carousel-control-prev" type="button" onClick={() => props.handleLevelChange(-1)}
        data-bs-target="#carouselExampleControls">
          <span className="carousel-control-prev-icon" aria-hidden="true"></span>
          <span className="visually-hidden">Previous</span>
        </button>
        <button className="carousel-control-next" type="button" onClick={() => props.handleLevelChange(1)} 
        data-bs-target="#carouselExampleControls">
          <span className="carousel-control-next-icon" aria-hidden="true"></span>
          <span className="visually-hidden">Next</span>
        </button>
      </div>
    </div>
    I make questions.


    <div className="input-group mb-1">
      <span className="input-group-text" id="basic-addon1">Pergunta</span>
      <input autoFocus={true} required='required' type="text" className="form-control" name='question' placeholder="O que será requisitado na resposta?" aria-label="Pergunta" aria-describedby="basic-addon1" />
      <span className="input-group-text" id="basic-addon2"><div id='imaging' className='d-inline-block'></div></span>
    </div>
    <div className="d-grid">
      <button type="submit" className="btn btn-primary">Criar Nova Questão</button>
    </div>
  </form>
  )
}