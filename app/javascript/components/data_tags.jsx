import React, { useState } from "react";
import ReactDOM from 'react-dom'
import { TagsInput } from "react-tag-input-component";

const Example = () => {
  const [selected, setSelected] = useState(tags);

  return (
    <div className='tagging'>
      <input type='hidden' name='tags' value={JSON.stringify(selected)} />
      <TagsInput
        value={selected}
        onChange={setSelected}
        placeHolder="Temas"
      />
      Pressione Enter ou Go para adicionar um novo tema.
    </div>
  );
};

if (document.getElementById('tags') != null) {
  ReactDOM.render(<Example />,document.getElementById('tags'))
};