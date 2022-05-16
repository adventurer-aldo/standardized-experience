import React from 'react'
import ReactDOM from 'react-dom'

class QuestionImage extends React.Component {
  onImageChange = (event) => {
    if (event.target.files && event.target.files[0]) {
      let reader = new FileReader();
      reader.onload = (e) => {
        this.setState({image: e.target.result});
      };
      reader.readAsDataURL(event.target.files[0]);
    }
  }

  render() { return <div>
    <button type="button" className='bg-transparent border-0' data-bs-toggle="modal" data-bs-target="#exampleModal" tabIndex='-1'>
      <i className="fa fa-picture-o"></i>
    </button>
    
    <div className="bg-opacity-50 bg-dark modal fade" id="exampleModal" tabIndex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title text-center" id="exampleModalLabel">Anexar Imagem</h5>
            <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div className="modal-body text-start">
          <img id="target" src={this.state.image}/>
            <br />
            <input type="file" onChange={this.onImageChange} className="filetype" id="group_image" accept="image/*" />
            <div className="form-check form-switch">
              <input className="form-check-input" defaultChecked={reuse_image} name='reuse_image' type="checkbox" role="switch" id="flexSwitchCheckDefault" />
              <label className="form-check-label" htmlFor="flexSwitchCheckDefault">Usar imagem anterior?</label>
            </div>
            Usar imagem de questão específica: <input name='reuse_id' className='form-control w-25 d-inline-block' type='number' min='0' defaultValue='0' />
            <br /><div className='fs-7 text-muted text-wrap'>Use 0 para usar a última messagem submetida ou especifique uma ID exata. 
            Deve ter (Imagem anterior) selecionado.
            </div>
          </div>
          <div className="modal-footer">
            <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  }
}

if (document.getElementById('imaging') != null ) {
ReactDOM.render(<QuestionImage /> ,
document.getElementById("imaging"))
}