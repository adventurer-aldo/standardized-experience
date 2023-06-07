function JourneyBar(props) {  
  [progressBar, setProgressBar] = React.useState(0);
  [currentLevel, setCurrentLevel] = React.useState(0);
  [levels, setLevels] = React.useState([]);
  
  React.useEffect(() => {
    setProgressBar(new Date().getTime());
    var lastTime = defineLevels(props.startTime);
    let currentTime = new Date().getTime();
    if (currentTime <= lastTime) {
      const progressInterval = setInterval(() => {
        setProgressBar(new Date().getTime());
      },1000)
    } else {
      if (typeof progressInterval !== 'undefined') clearInterval(progressInterval);
    }
    return () => clearInterval(progressInterval);
  },[])
  
  React.useEffect(() => {
    if (levels !== []){
      let currentLevelTemp = currentLevel;
      if ((calculateLevel() !== currentLevelTemp) && 
      (new Date().getTime() >= levels[currentLevelTemp] && currentLevelTemp !== 7)) {
        setCurrentLevel(calculateLevel());
        if (currentLevel !== 0) reloadJourneyElements();
      };
      if (typeof progressInterval !== 'undefined' && currentLevelTemp === 7) clearInterval(progressInterval);
    }
  }, [progressBar])
  
    const defineLevels = (beginning) => {
      new_levels = [];
      new_levels.push(beginning);
      [10, 20, 31, 38, 54, 75].forEach((item) => {
        new_levels.push(beginning + (props.chairsNum * (item * 61.25 * 1000)));
      })
      setLevels(new_levels);
      return new_levels[new_levels.length - 1]
    };
  
    const calculateLevel = () => {
      let newDate = new Date().getTime();
      let pastlevels = levels.filter((level) => {
        return level > newDate
      }).length;
      return (7 - pastlevels);
    };
    
  const reloadJourneyElements = () => {
    axios.get('/')
    .then((response) => {
      let parser = new DOMParser();
      let newDoc = parser.parseFromString(response.data, 'text/html');
      let bgmElement = document.getElementById('bgm');
      if (bgmElement.src !== newDoc.getElementById('bgm').src) {
        bgmElement.src = newDoc.getElementById('bgm').src;
        bgmElement.load()
      };
      ['journey-level', 'journey-cheer', 'journey'].forEach((element) => {
        document.getElementById(element).innerHTML = newDoc.getElementById(element).innerHTML;
      })
    });
  };

  const handleClick = () => {
    axios.post('/api/journeys', {authenticity_token: props.csrf_token})
    .then(() => {
      reloadJourneyElements();
      defineLevels((new Date().getTime()) - 500);
      setCurrentLevel(calculateLevel());
      const progressInterval = setInterval(() => {
        setProgressBar(new Date().getTime());
      },1000)
    })
  }

  return (
    <JourneyBarDisplay 
    reloadJourney={reloadJourneyElements} 
    bar={progressBar}
    csrf_token={props.csrf_token}
    level={currentLevel}
    startTime={levels[0]}
    lastTime={levels[levels.length - 1]}
    handleClick={handleClick}
    />
  )
}