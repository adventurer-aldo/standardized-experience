function PaginationQuestion(props) {

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
                      <label htmlFor="searchQuestion" className="form-label">Question:</label>
                      <input type="text" className="form-control" id="searchQuestion" placeholder="Cadeira" name="question"
                             onChange={(event) => props.handleChange(event, 'question')} value={props.query.question} />
                  </div>
                  <div className="mb-3">
                      <label htmlFor="searchAnswer" className="form-label">Answer:</label>
                      <input type="text" className="form-control" id="searchAnswer" placeholder="Cadeira" name="answer"
                             onChange={(event) => props.handleChange(event, 'answer')} value={props.query.answer} />
                  </div>
                  <div className="form-floating">
                      <select value={props.query.subject} name="subject" className="form-select" id="searchSubject"
                              onChange={(event) => props.handleChange(event, 'subject')}>
                          <option value="">Any</option>
                          {props.subjects.map((subject, index) => <option key={index} value={subject[0]}>{subject[1]}</option>)}
                      </select>
                      <label htmlFor="searchSubject">Subject</label>
                  </div>
                  <div className="mb-3 form-floating">
                      <select value={props.query.level} name="level" className="form-select" id="searchLevel"
                              onChange={(event) => props.handleChange(event, 'level')}>
                          <option value="">Any</option>
                          <option value="1">1st Test</option>
                          <option value="2">2nd Test</option>
                          <option value="3">Course Work</option>
                          <option value="4">Exam</option>
                      </select>
                      <label htmlFor="searchLevel">Level</label>
                  </div>
                  <div className="mb-3 form-floating">
                      <select value={props.query.questionTypes} name="question_types" className="form-select" id="searchType"
                              onChange={(event) => props.handleChange(event, 'questionTypes')}>
                          <option value="">Any</option>
                          <option value="open">Open</option>
                          <option value="caption">List</option>
                          <option value="formula">Formula</option>
                          <option value="choice">Choice</option>
                          <option value="veracity">Veracity</option>
                          <option value="match">Match</option>
                          <option value="fill">Fill</option>
                          <option value="table">Table</option>
                      </select>
                      <label htmlFor="searchType">Question type</label>
                  </div>
                  <div className="mb-3 form-floating">
                      <select value={props.query.order} name="order" className="form-select" id="searchOrder"
                              onChange={(event) => props.handleChange(event, 'order')}>
                          <option value="ASC">Ascendending</option>
                          <option value="DESC">Descending</option>
                      </select>
                      <label htmlFor="searchOrder">Results order</label>
                  </div>
                  <button className="btn btn-close" onClick={props.handleRestore}></button>
              </div>
          </div>
      </li>
    </ul>
  )
}