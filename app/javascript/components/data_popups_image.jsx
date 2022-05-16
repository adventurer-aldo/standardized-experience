import React from 'react'
import ReactDOM from 'react-dom'
import Popup from 'reactjs-popup';
import 'reactjs-popup/dist/index.css';

class OldImage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      checked: reuse_image
    }
  }

  handleOld() {
    let temp = this.state.checked == "0" ? "1" : "0"
    this.setState({checked: temp })
    const hidden = document.getElementById("reuse_image");
    hidden.value = temp
  }

  render() {
    return (<input id='old_image' 
    type='checkbox' 
    name='urahara_news'
    value={this.state.checked} 
    onChange={() => this.handleOld() }
    checked={this.state.checked == "1"} />
    )
  }
}

if (document.getElementById('imaging') != null ) {
ReactDOM.render( <div>
  <button type="button" id='imagingButton' data-bs-toggle="modal" data-bs-target="#exampleModal">
    <i className="fa fa-plus"></i>
  </button>
  
  <div className="bg-opacity-50 bg-dark modal fade" id="exampleModal" tabIndex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div className="modal-dialog">
      <div className="modal-content">
        <div className="modal-header">
          <h5 className="modal-title text-center" id="exampleModalLabel">Anexar Imagem</h5>
          <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div className="modal-body">
          <img className='imageData' src={document.getElementById('image').src} />
          <br />
          <div className="form-check form-switch">
            <input className="form-check-input" defaultChecked={reuse_image} name='reuse_image' type="checkbox" role="switch" id="flexSwitchCheckDefault" />
            <label className="form-check-label" htmlFor="flexSwitchCheckDefault">Usar imagem anterior?</label>
          </div>

          Usar imagem de questão específica: <input name='reuse_id' type='number' min='0' defaultValue='0' />
          <br /><span>Use 0 para usar a última messagem submetida ou especifique uma ID exata. <br />
            Deve ter (Imagem anterior) selecionado. [NOT IMPLEMENTED!]
          </span>
        </div>
        <div className="modal-footer">
          <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
  </div>,
document.getElementById("imaging"))
}