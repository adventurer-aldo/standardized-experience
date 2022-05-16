import React from "react";
import ReactDOM from 'react-dom'
import { WithContext as ReactTags } from 'react-tag-input';

const suggestions = existing_tags.map(tag => {
  return {
    id: tag,
    text: tag
  };
});

const pre_tags = temas.map(tema => {
  return {
    id: tema,
    text: tema
  };
});

const KeyCodes = {
  comma: 188,
  enter: 13
};

const delimiters = [KeyCodes.comma, KeyCodes.enter];

const App = () => {
  const [tags, setTags] = React.useState(pre_tags);


  const handleDelete = i => {
    setTags(tags.filter((tag, index) => index !== i));
  };

  const handleAddition = tag => {
    setTags([...tags, tag]);
  };

  const handleDrag = (tag, currPos, newPos) => {
    const newTags = tags.slice();

    newTags.splice(currPos, 1);
    newTags.splice(newPos, 0, tag);

    // re-render
    setTags(newTags);
  };

  const handleTagClick = index => {
    console.log('The tag at index ' + index + ' was clicked');
  };

  return (
    <div className="app">
      <h1> React Tags Example </h1>
      <input type='hidden' name="tags" value={JSON.stringify(tags.map(tema => {
  return tema.text;
})
)} />
      <div>
        <ReactTags
          tags={tags}
          suggestions={suggestions}
          delimiters={delimiters}
          handleDelete={handleDelete}
          handleAddition={handleAddition}
          handleDrag={handleDrag}
          handleTagClick={handleTagClick}
          inputFieldPosition="bottom"
          autocomplete={false}
          classNames={{
            tags: 'tagsClass',
            tagInput: 'tagInputClass',
            tagInputField: 'form-control form-control-sm',
            selected: 'selectedClass',
            tag: 'btn btn-warning p-1 m-1',
            remove: 'removeClass',
            suggestions: 'suggestionsClass',
            activeSuggestion: 'activeSuggestionClass',
            editTagInput: 'editTagInputClass',
            editTagInputField: 'editTagInputField',
            clearAll: 'clearAllClass',
          }}
        />
      </div>
    </div>
  );
};

if (document.getElementById('tags') != null) {
  ReactDOM.render(<App />,document.getElementById('tags'))
};