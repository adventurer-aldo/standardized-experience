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
    value={this.state.checked} 
    onChange={() => this.handleOld() }
    checked={this.state.checked == "1"} />
    )
  }
}
if (document.getElementById('imaging') != null ) {
ReactDOM.render(
  <Popup
    trigger={<button id='imagingButton' type='button' ><i className="fa fa-plus"></i></button>}
    modal
    nested
  >
    {close => (
      <div className="modal">
        <button className="close" onClick={close}>
          ✕
        </button>
        <div className="header"> Anexar Imagem </div>
        <div className="content">
          {' '}
          <img className='imageData' src={document.getElementById('image').src} />
          <br />
          Imagem anterior? <OldImage /><br />
          Usar imagem de questão específica:
          <br /><span>Use 0 para usar a última messagem submetida ou especifique uma ID exata. <br />
            Deve ter (Imagem anterior) selecionado. [NOT IMPLEMENTED!]
          </span>
        </div>
      </div>
    )}
  </Popup>,
document.getElementById("imaging"))
}