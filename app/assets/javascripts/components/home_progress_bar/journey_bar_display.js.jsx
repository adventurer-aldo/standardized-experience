function JourneyBarDisplay(props) {
  return (
    <div>
      <div className="progress">
        <div 
        className="progress-bar progress-bar-striped progress-bar-animated bg-success" 
        style={
          {
            width: `${((props.bar - props.startTime) / (props.lastTime - props.startTime)) * 100}%`
          }
        } 
        role="progressbar" 
        aria-valuenow={props.bar} 
        aria-valuemin={props.startTime} 
        aria-valuemax={props.lastTime}>

        </div>
      </div>
      <div style={{display: (props.level === 7 ? '' : 'none')}}>
          <button 
          onClick={props.handleClick}
          className="btn btn-primary">
            A sua jornada terminou. Começe uma nova agora!</button>
      </div>
    </div>
  )
}