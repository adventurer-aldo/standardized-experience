function PaginationSubject(props) {

  return (
    <ul className="text-nowrap pagination justify-content-center my-1">
      <li><button className={`rounded-start page-item page-link${props.page <= 0 || props.pages <= 0 ? ' disabled' : ''}`}
      onClick={() => props.handleClick(0)} disabled={props.page <= 0 || props.pages <= 0}>
          <i className="bi-skip-backward-fill"></i>
      </button></li>
      <li><button className={`page-item page-link${props.page <= 0 || props.pages <= 0 ? ' disabled' : ''}`}
      onClick={() => props.handleClick(props.page - 1)} disabled={props.page <= 0 || props.pages <= 0}>
          <i className="bi-caret-left-fill"></i>
      </button></li>
      <li className="overflow-scroll">
      {Array(props.pages).fill('').map((_page, index) => {
        return <button key={index} className={`d-inline-block page-item page-link${props.page === index ? ' active' : ''}`}
        onClick={() => props.handleClick(index)} >{index + 1}</button>
      })}</li>
      <li><button className={`page-item page-link${props.page >= props.pages - 1 || props.pages <= 0 ? ' disabled' : ''}`}
      onClick={() => props.handleClick(props.page + 1)}
      disabled={props.page >= props.pages - 1 || props.pages <= 0}>
          <i className="bi-caret-right-fill"></i>
      </button></li>
      <li>
        <button className={`page-item page-link${props.page >= props.pages - 1 || props.pages <= 0 ? ' disabled' : ''}`}
        onClick={() => props.handleClick(props.pages - 1)}
        disabled={props.page >= props.pages - 1 || props.pages <= 0}>
            <i className="bi-skip-forward-fill"></i>
        </button>
      </li>
      <li className="" >
          <div className="dropdown">
              <button type="button" className="btn btn-primary dropdown-toggle rounded-0 rounded-end"
                      data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
                  Pesquisar
              </button>
              <div className="dropdown-menu p-4" style={{minWidth: '43vw'}}>
                  <div className="mb-3">
                      <label htmlFor="searchTitle" className="form-label">Nome:</label>
                      <input type="text" className="form-control" id="searchTitle" placeholder="Cadeira" name="title"
                             onChange={(event) => props.handleChange(event, 'title')} value={props.query.title} />
                  </div>
                  <div className="mb-3">
                      <label htmlFor="searchDescription" className="form-label">Descrição:</label>
                      <textarea className="form-control" id="searchDescription" name="description"
                             placeholder="Esta cadeira é sobre..." value={props.query.description}
                             onChange={(event) => props.handleChange(event, 'description')}/>
                  </div>
                  <div className="form-floating">
                      <select value={props.query.formula} name="formula" className="form-select" id="searchFormula"
                              onChange={(event) => props.handleChange(event, 'formula')}>
                          <option value="">Qualquer</option>
                          {props.formulas.map((formula, index) => <option key={index} value={index}>{formula}</option>)}
                      </select>
                      <label htmlFor="searchFormula">Fórmula da média</label>
                  </div>
                  <div className="form-floating">
                      <select value={props.query.practical} name="practical" className="form-select" id="searchPractical"
                              onChange={(event) => props.handleChange(event, 'practical')}>
                          <option value="">Qualquer</option>
                          <option value="0">Teórica</option>
                          <option value="1">Prática</option>
                      </select>
                      <label htmlFor="searchPractical">Avaliação</label>
                  </div>
                  <div className="mb-3 form-floating">
                      <select value={props.query.order} name="order" className="form-select" id="searchOrder"
                              onChange={(event) => props.handleChange(event, 'order')}>
                          <option value="ASC">Ascendente</option>
                          <option value="DESC">Descendente</option>
                      </select>
                      <label htmlFor="searchOrder">Ordem dos resultados</label>
                  </div>
                  <button className="btn btn-close" onClick={props.handleRestore}></button>
              </div>
          </div>
      </li>
    </ul>
  )
}