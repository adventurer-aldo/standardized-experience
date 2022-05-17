import React from "react";
import ReactDOM from 'react-dom'
import { WithContext as ReactTags } from 'react-tag-input';

class RemoveComponent extends React.Component {
  render() {
    const { className, onRemove } = this.props;
     return (
        <button type="button" className={className} onClick={onRemove} aria-label="Close"></button>

     )
  }
}

const App = () => {
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
    <div className="app"><input type='hidden' name="tags" value={JSON.stringify(tags.map(tema => {
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
          placeholder="Pressione Enter ou , para introduzir um tema."
          inputFieldPosition="bottom"
          autocomplete={false}
          autofocus={false}
          removeComponent={RemoveComponent}
          classNames={{
            tags: 'tagsClass',
            tagInput: 'tagInputClass',
            tagInputField: 'form-control form-control-sm',
            selected: 'selectedClass',
            tag: 'btn btn-warning p-1 m-1',
            remove: 'btn-close align-middle h-25',
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