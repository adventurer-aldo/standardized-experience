function Lesson(props) {
  [points, setPoints] = React.useState(props.points);
  [progress, setProgress] = React.useState(0);
  [health, setHealth] = React.useState(100);
  [attempts, setAttempts] = React.useState([]);
  [decoys, setDecoys] = React.useState([]);
  [alternatives, setAlternatives] = React.useState([]);
  [sounds, setSounds] = React.useState({
    applause: [new Audio(props.sounds.applause[0]), new Audio(props.sounds.applause[1])],
    mistake: new Audio(props.sounds.mistake), correct: new Audio(props.sounds.correct),
    damage: new Audio(props.sounds.damage), next: new Audio(props.sounds.next),
    input: new Audio(props.sounds.input), cancel: new Audio(props.sounds.cancel)
  });

  React.useEffect(() => {
    setAttempts(Array(countAttempts(points[progress])).fill(''))
  },[])

  React.useEffect(() => {
    if (progress > points.length / 1.5 && document.getElementById('bgm').src !== props.fire) {
      document.getElementById('bgm').src = props.fire;
      document.getElementById('bgm').load();
    }
  },[progress])

  React.useEffect(() => {
    if (health <= 0) {
      window.location = '/aulas'
    }
  },[health])

  const getNextDecoys = (target) => {
    if (target.choices.length < 1 || !['choice','veracity'].includes(target.question_type)) return;
    let amount = Math.floor(Math.random() * target.choices.length)
    let choices = target.choices
    choices.sort(() => Math.floor(Math.random() * 5) == 0)
    let newDecoys = [];
    for (let i=0;i<amount;i++) {
      newDecoys.push(choices[i][0]);
    }
    return newDecoys
  }
  const handleChange = (event, attemptIndex) => {
    let value = event.target.value;
    let completeness = determineCompleteness(value.toLowerCase());
    if (value.length > attempts[attemptIndex].length) {
      if ([2,1].includes(completeness)) {
        if (completeness == 2) {
          sounds.correct.play();
          if (progress == points.length - 1) {
            console.log("You're finished!")
            setAttempts([value])
            axios.patch('/api/lessons', {lesson: {id: props.id, grade: health / 100 * 20}})
          } else {
            if (['choice','veracity'].includes(points[progress+1].question_type)) setAlternatives(getNextDecoys(points[progress+1]).concat(points[progress+1].answers))
            setAttempts(Array(countAttempts(points[progress+1])).fill(''))
            setProgress(prevProgress => {
              return prevProgress + 1;
            })
          }
        } else {
          setAttempts([value])
          sounds.input.play();
        } 
      } else {
        sounds.damage.play();
        setHealth(prev => prev - attempts.length)
        setAttempts([value])
      }
    } else {
      sounds.cancel.play();
      setAttempts([value])
    }
  }

  const countAttempts = (point) => {
    if (point.question_type == 'open' || (point.question_type == 'choice' && point.answers.length == 1)) {
      return 1
    } else if (['caption','match','table','fill'].includes(point.question_type)) {
      return point.answers.length
    } else if (['choice','veracity'].includes(point.question_type)) {
      0
    }
  }

  const getAlternatives = (target) => {

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

  return (
    <div className="text-bg-dark bg-opacity-75 fs-6 p-3 rounded overflow-scroll h-100">
      <Bars health={health} progress={progress} points={points.length} />
      <div className="fs-3 text-center p-2 fw-bold">{props.tag}</div>
      <div className="fs-5 p-3 text-center">{points[progress].question}</div>
      <LessonSolver attempts={attempts} alternatives={alternatives} point={points[progress]} handleChange={handleChange}/>
    </div>
  )
}