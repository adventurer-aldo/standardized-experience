function Bars(props) {
  return (
    <div>
      <div className="progress mb-1">
        <div className={"progress-bar-striped progress-bar-animated progress-bar text-dark fw-bold " + (props.progress > props.points / 1.5 ? 'bg-danger' : 'bg-warning')} role="progressbar" style={{width: `${props.progress / props.points * 100}%`}} aria-valuenow={props.progress / props.points * 100} aria-valuemin="0" aria-valuemax="100">{(props.progress / props.points * 100).toPrecision(3)}%</div>
      </div>
      <div className="progress" style={{height: 30}}>
        <div className={"fs-5 progress-bar text-dark fw-bold bg-gradient " + (50 > props.health ? (20 > props.health ? 'bg-danger' : 'bg-warning') : 'bg-success')} role="progressbar" style={{width: `${props.health}%`}} aria-valuenow={props.health} aria-valuemin="0" aria-valuemax="100">{props.health}/100 HP</div>
      </div>
    </div>
  )
}