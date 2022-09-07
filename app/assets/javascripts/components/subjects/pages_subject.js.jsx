function PaginationSubject(props) {

  return (
    <ul className="text-nowrap pagination justify-content-center my-1">
      <li><button className={`rounded-start page-item page-link${props.page <= 0 || props.pages == 0 ? ' disabled' : ''}`}
      onClick={() => props.handleClick(0)} disabled={props.page <= 0 || props.pages == 0}>
        Primeiro
      </button></li>
      <li><button className={`page-item page-link${props.page <= 0 || props.pages == 0 ? ' disabled' : ''}`}
      onClick={() => props.handleClick(props.page - 1)} disabled={props.page <= 0 || props.pages == 0}>
        Anterior
      </button></li>
      <li className="overflow-scroll">
      {Array(props.pages).fill('').map((_page, index) => {
        return <button key={index} className={`d-inline-block page-item page-link${props.page === index ? ' active' : ''}`}
        onClick={() => props.handleClick(index)} >{index + 1}</button>
      })}</li>
      <li><button className={`page-item page-link${props.page >= props.pages - 1 || props.pages == 0 ? ' disabled' : ''}`} 
      onClick={() => props.handleClick(props.page + 1)}
      disabled={props.page >= props.pages - 1 || props.pages == 0}>
        Próximo
      </button></li>
      <li>
        <button className={`page-item page-link${props.page >= props.pages - 1 || props.pages == 0 ? ' disabled' : ''}`} 
        onClick={() => props.handleClick(props.pages - 1)}
        disabled={props.page >= props.pages - 1 || props.pages == 0}>
          Último
        </button>
      </li>
      <li>
        <span className="rounded-0 input-group-text d-inline-block" id="basic-addon1">Pesquisar:</span>
        <input type="text" value={props.search} onChange={(event) => props.handleChange(event)}
        className="rounded-end rounded-0 form-control d-inline-block" placeholder="Nome da cadeira" 
        aria-label="Nome da cadeira" aria-describedby="basic-addon1" style={{width: 'auto'}} />
      </li>
    </ul>
  )
}