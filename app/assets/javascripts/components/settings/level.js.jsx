const PrefLevel = (props) => {
  [level, setLevel] = React.useState(1);

  let changeLevel = (math) => {
    setLevel(prev => {
      let res = prev + math
      if (res == 4) {
        return 0
      } else if (res == -1) {
        return 3
      } else {
        return res
      }
    })
  }

  return <div id="carouselExampleControls" className="carousel carousel-fade slide w-25 text-center text-bg-primary p-2 fw-bold rounded-end">
    <div className="carousel-inner fs-4">
      <div className={`carousel-item ${level == 0 ? 'active' : ''}`}>
        All Levels
      </div>
      <div className={`carousel-item ${level == 1 ? 'active' : ''}`}>
        1st Test
      </div>
      <div className={`carousel-item ${level == 2 ? 'active' : ''}`}>
        2nd Test
      </div>
      <div className={`carousel-item ${level == 3 ? 'active' : ''}`}>
        Exam
      </div>
    </div>
    <button tabIndex='-1' className="carousel-control-prev" type="button" onClick={() => changeLevel(-1)}
      data-bs-target="#carouselExampleControls">
      <span className="carousel-control-prev-icon" aria-hidden="true"></span>
      <span className="visually-hidden">Previous Level</span>
    </button>
    <button tabIndex='-1' className="carousel-control-next" type="button" onClick={() => changeLevel(1)}
      data-bs-target="#carouselExampleControls">
      <span className="carousel-control-next-icon" aria-hidden="true"></span>
      <span className="visually-hidden">Next Level</span>
    </button>
  </div>
}