function SubjectList(props) {
  if (props.subjects === null) {
    return Array(6).fill('').map((_subject, index) => 
    <div key={index} className="card m-auto" style={{width: "18rem"}}>
      <div className="card-header">
      <ul className="nav nav-pills card-header-pills">
        <li className="nav-item">
          <button type="button"
          className="btn btn-secondary">Study
          </button>
        </li>
      </ul>
      </div>
      <div className="card-body">
        <h5 className="card-title placeholder-wave">
          <span className="placeholder placeholder-lg col-6"></span>
        </h5>
        <p className="card-text">
          <span className="placeholder col-7"></span>
          <span className="placeholder col-2"></span>&nbsp;<span className="placeholder col-5"></span>
          &nbsp;<span className="placeholder col-1"></span>&nbsp;<span className="placeholder col-4"></span>
        </p>
      </div>
      <ul className="list-group list-group-flush">
        <li className="list-group-item"><strong>Questions:</strong> <span className="placeholder placeholder-wave col-3"></span></li>
        <li className="list-group-item"><strong>Average:</strong> <span className="placeholder placeholder-wave col-4"></span></li>
        <li className="list-group-item"><strong>Timed:</strong> <span className="placeholder placeholder-wave col-2"></span></li>
        <li className="list-group-item"><strong>Course Work:</strong> <span className="placeholder placeholder-wave col-4"></span></li>
      </ul>
    </div>
    )
  } else {
    return props.subjects.map((subject) => 
      <div key={subject.id} className="card m-1" style={{width: "18rem"}}>
        <div className="card-header">
        <ul className="nav nav-pills card-header-pills">
          <li className="nav-item">
            <button type="button"
            className={"btn btn-" + (props.evaluables.includes(subject.id) ? 'primary' : 'secondary')}
            onClick={() => props.handleEvaluate(subject.id)}>Study
            </button>
          </li>{subject.creator == props.stat ? (
            <li className="nav-item mx-2">
              <button className={`btn btn-${props.editing === subject.id ? 'warning' : 'secondary'}`}
              onClick={() => props.handleEditing(subject.id)}>
                Edit
              </button>
            </li>) : ''}{subject.creator == props.stat ? (
            <li className="nav-item">
              <button type='button' className='btn btn-danger' 
              data-bs-toggle="modal" data-bs-target={`#eraseModal${subject.id}`} >
                Delete
              </button>
            </li>) : ''}
        </ul>
        </div>
        <div className="bg-opacity-50 bg-dark modal fade" 
        id={`eraseModal${subject.id}`} tabIndex="-1" 
        aria-labelledby={`eraseModalLabel${subject.id}`} aria-hidden="true">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title" id={`eraseModalLabel${subject.id}`}>Confirmação</h5>
                <button type="button" className="btn-close" data-bs-dismiss="modal" 
                aria-label="Close"></button>
              </div>
              <div className="modal-body">
                Tem certeza de que pretende apagar esta cadeira?<br/><b>{ subject.title }</b><br /><br />
                Todas perguntas que pertencem a esta cadeira, suas e de colaboradores, serão também apagadas no processo.<br/>
                <strong>Este processo é irreversível!</strong>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">
                  No...
                </button>
                <button type="button" onClick={() => props.handleDelete(subject.id)} name="operation" 
                value="delete" className="btn btn-danger" data-disable-with="Certeza!"
                data-bs-dismiss="modal">
                Sure!
                </button>
              </div>
            </div>
          </div>
        </div>
        <div className="card-body">
          <h5 className="card-title">{ subject.title }</h5>
          <p className="card-text">{ subject.description }</p>
        </div>
        <ul className="list-group list-group-flush">
          <li className="list-group-item"><strong>Questions:</strong> { subject.questions }</li>
          <li className="list-group-item"><strong>Average:</strong> { props.formulas[subject.formula] }</li>
          <li className="list-group-item"><strong>Timed:</strong> {subject.practical == 1 ? 'Yes' : 'No'}</li>
          <li className="list-group-item"><strong>Course Work:</strong> Test</li>
          <li className="list-group-item"><strong>Owner:</strong> {subject.creator_name}</li>
        </ul>
      </div>
    )
  }
}