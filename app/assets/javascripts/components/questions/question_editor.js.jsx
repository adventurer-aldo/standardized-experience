class QuestionEditor extends React.Component {

  render() {
    return (
    <form autoComplete="off" encType="multipart/form-data" acceptCharset="UTF-8">
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
}