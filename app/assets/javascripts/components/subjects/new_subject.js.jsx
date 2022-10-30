function NewSubject(props) {

  return <form autoComplete="off" encType="multipart/form-data" acceptCharset="UTF-8" onSubmit={(event) => props.handleSubmit(event, props.editing)}>
    <input type='hidden' name='authenticity_token' value={props.auth_token} />
    <input type='hidden' name='stat_id' value={props.stat} />
    <div className="form-floating mt-1">
     <input type="text" className="form-control" id="floatingInput" 
     placeholder="What's the name of the subject?" name="subject[title]" required="required"
     value={props.data.title} onChange={(event) => props.handleChange(event, 'title')}/>
     <label htmlFor="floatingInput">
        {props.editing === null ? "What's the name of the subject you wish to add?" : `What will be the new name of the subject "${props.originalName}"`}
      </label>
    </div>
    <div className="form-floating my-1">
      <input type="text" className="form-control" placeholder="What is this subject about?"
      name="subject[description]" id="floatingTextarea" value={props.data.description}
      onChange={(event) => props.handleChange(event, 'description')} />
      <label htmlFor="floatingTextarea">What is this subject about?</label>
    </div>
    <div className="row g-3 mb-1">
      <div className="col-md">
        <div className="form-floating">
          <select id="floatingMedia" className="form-select form-select-sm" 
          aria-label=".form-select-sm example"  name='subject[formula]' value={props.data.formula}
          onChange={(event) => props.handleChange(event, 'formula')}>
          {props.formulas.map((formula, index) => <option key={index} value={index}>{formula}</option>)}
          </select>
          <label htmlFor="floatingMedia">Average Formula</label>
        </div>
      </div>
      <div className="col-md">
        <div className="form-floating">
          <select className="form-select" id="floatingPractical" value={props.data.practical}
          onChange={(event) => props.handleChange(event, 'practical')}>
            <option value="0">Regular</option>
            <option value="1">Timed</option>
          </select>
          <label htmlFor="floatingPractical">Evaluation Method</label>
        </div>
      </div>
      <div className="col-md">
        <div className="form-floating">
          <select className="form-select" name='subject[job_type]' id="floatingJob" 
          value={props.data.job_type} onChange={(event) => props.handleChange(event, 'job_type')}>
            <option value="0">Test</option>
          </select>
          <label htmlFor="floatingJob">Course Work Type</label>
        </div>
      </div>
    </div>
    <div className="text-end">
      <div className="form-check form-check-inline form-switch form-check-reverse">
        <input className="form-check-input" type="checkbox" id="allow_foreign" value={props.data.allow_foreign}
        checked={props.data.allow_foreign == '1'} onChange={(event) => { event.target.value = event.target.value == '0' ? '1' : '0';props.handleChange(event, 'allow_foreign')}} />
        <label className="form-check-label" htmlFor="allow_foreign">Allow foreign questions</label>
      </div>
      <div className="form-check form-check-inline form-switch form-check-reverse">
        <input className="form-check-input" type="checkbox" id="flexSwitchCheckReverse" value={props.data.visibility}
        checked={props.data.visibility == '1'} onChange={(event) => { event.target.value = event.target.value == '0' ? '1' : '0';props.handleChange(event, 'visibility')}} />
        <label className="form-check-label" htmlFor="flexSwitchCheckReverse">Private</label>
      </div>
    </div>
  <div className='d-grid'>
    <button className={`btn btn-${props.editing === null ? 'primary' : 'warning'}`} type="submit">
      {`${props.editing == null ? 'Create New' : 'Edit'} Subject`}
    </button>
  </div>
  </form>
}