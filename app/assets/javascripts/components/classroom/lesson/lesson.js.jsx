function Lesson(props) {
  [points, setPoints] = React.useState(props.points);
  [progress, setProgress] = React.useState(0);
  [health, setHealth] = React.useState(100);
  [attempts, setAttempts] = React.useState(countAttempts(props.points[0]))
  [sounds, setSounds] = React.useState({
    applause: [new Audio(props.sounds.applause[0]), new Audio(props.sounds.applause[1])],
    mistake: new Audio(props.sounds.mistake), correct: new Audio(props.sounds.correct),
    damage: new Audio(props.sounds.damage), next: new Audio(props.sounds.next),
    input: new Audio(props.sounds.input), cancel: new Audio(props.sounds.cancel)
  });

  const handleChange = (event, attemptIndex) => {
    let value = event.target.value.trim().toLowerCase();
    let completeness = determineCompleteness(value);
    if (value.length > points[progress].attempt[attempt].length) {
      if ([2,1].includes(completeness)) {
        if (completeness == 2) {
          sounds.correct.play();
        } else {
          sounds.input.play();
        } 
        setAttempts(prev => {
          p = prev;
          p[attemptIndex] = value;
          return p
        })
      } else {
        sounds.damage.play();
      }
    } else {
      sounds.cancel.play();
    }
  }

  const countAttempts = (point) => {
    if (point.question_type == 'open') {
      return 1
    } else if (['choice','caption','match','table','fill'].includes(point.question_type)) {
      return point.answers.length
    } else if (point.question_type == 'veracity') {
      2
    }
  }

  const determineCompleteness = (value) => {
    if (points[progress].question_type == 'open') {
      if (points[progress].answers.map(answer => answer.toLowerCase()).includes(value)) {
        return 2
      } else if (points[progress].answers.filter(answer => answer.toLowerCase().indexOf(value) == 0).length > 0) {
        return 1
      } else {
        return 0
      }
    }
  }

  React.useEffect(() => {
    if (progress > points.length / 1.5) {
      document.getElementById('bgm').src = props.fire;
      document.getElementById('bgm').load();
    }
  },[progress])

  return (
    <div className="text-bg-dark bg-opacity-75 fs-6 p-3 rounded overflow-scroll h-100">
      <div className="progress mb-1">
        <div className={"progress-bar-striped progress-bar-animated progress-bar text-dark fw-bold " + (progress > points.length / 1.5 ? 'bg-danger' : 'bg-warning')} role="progressbar" style={{width: `${progress / points.length * 100}%`}} aria-valuenow={progress / points.length * 100} aria-valuemin="0" aria-valuemax="100">{(progress / points.length * 100).toPrecision(4)}%</div>
      </div>
      <div className="progress" style={{height: 30}}>
        <div className={"fs-5 progress-bar text-dark fw-bold " + (50 > health ? (20 > health ? 'bg-danger' : 'bg-warning') : 'bg-success')} role="progressbar" style={{width: `${health}%`}} aria-valuenow={health} aria-valuemin="0" aria-valuemax="100">{health}/100 HP</div>
      </div>
      <div className="fs-3 text-center p-2 fw-bold">{props.tag}</div>
      <div className="fs-5 p-3 text-center">{points[progress].question}</div>
      <LessonSolver point={points[progress]} handleChange={handleChange}/>
    </div>
  )
}