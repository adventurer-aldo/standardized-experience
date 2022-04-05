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

ReactDOM.render(
  <Popup
    trigger={<button id='imagingButton' type='button' ><i className="fa fa-plus"></i></button>}
    modal
    nested
  >
    {close => (
      <div className="modal">
        <button className="close" onClick={close}>
          X
        </button>
        <div className="header"> Attach Image </div>
        <div className="content">
          {' '}
          <img className='imageData' src={document.getElementById('image').src} />
          <br />
          Previous image? <OldImage /><br />
          Use image from set question:
          <br /><span>Set as 0 to use the last known message or specify an exact question ID. <br />
            Must have Previous Image enabled. [NOT IMPLEMENTED!]
          </span>
        </div>
      </div>
    )}
  </Popup>,
document.getElementById("imaging"))