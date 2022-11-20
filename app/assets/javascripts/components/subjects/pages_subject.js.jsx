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
                  Search
              </button>
              <div className="dropdown-menu p-4" style={{minWidth: '43vw'}}>
                  <div className="mb-3">
                      <label htmlFor="searchTitle" className="form-label">Name:</label>
                      <input type="text" className="form-control" id="searchTitle" placeholder="Name" name="title"
                             onChange={(event) => props.handleChange(event, 'title')} value={props.query.title} />
                  </div>
                  <div className="mb-3">
                      <label htmlFor="searchDescription" className="form-label">Description:</label>
                      <textarea className="form-control" id="searchDescription" name="description"
                             placeholder="Esta cadeira é sobre..." value={props.query.description}
                             onChange={(event) => props.handleChange(event, 'description')}/>
                  </div>
                  <div className="form-floating">
                      <select value={props.query.formula} name="formula" className="form-select" id="searchFormula"
                              onChange={(event) => props.handleChange(event, 'formula')}>
                          <option value="">Any</option>
                          {props.formulas.map((formula, index) => <option key={index} value={index}>{formula}</option>)}
                      </select>
                      <label htmlFor="searchFormula">Average Formula</label>
                  </div>
                  <div className="form-floating">
                      <select value={props.query.practical} name="practical" className="form-select" id="searchPractical"
                              onChange={(event) => props.handleChange(event, 'practical')}>
                          <option value="">Any</option>
                          <option value="0">Regular</option>
                          <option value="1">Timed</option>
                      </select>
                      <label htmlFor="searchPractical">Evaluation</label>
                  </div>
                  <div className="mb-3 form-floating">
                      <select value={props.query.order} name="order" className="form-select" id="searchOrder"
                              onChange={(event) => props.handleChange(event, 'order')}>
                          <option value="ASC">Ascending</option>
                          <option value="DESC">Descending</option>
                      </select>
                      <label htmlFor="searchOrder">Results' order</label>
                  </div>
                  <button className="btn btn-close" onClick={props.handleRestore}></button>
              </div>
          </div>
      </li>
    </ul>
  )
}