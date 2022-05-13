import React, { useState } from "react";
import ReactDOM from 'react-dom'
import { TagsInput } from "react-tag-input-component";

const Example = () => {
  const [selected, setSelected] = useState(["papaya"]);

  return (
    <div>
      <h1>Add Fruits</h1>
      <pre>{JSON.stringify(selected)}</pre>
      <TagsInput
        value={selected}
        onChange={setSelected}
        name="tags"
        placeHolder="enter tags"
      />
      <em>press enter or comma to add new tag</em>
    </div>
  );
};

if (document.getElementById('tags') != null) {
  ReactDOM.render(<Example />,document.getElementById('tags'))
};