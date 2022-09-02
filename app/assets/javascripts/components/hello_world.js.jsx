var HelloWorld = createReactClass({
  propTypes: {
    greeting: PropTypes.string
  },

  render: function() {
    return (
      <React.Fragment>
        Cumprimentos: {this.props.greeting}
      </React.Fragment>
    );
  }
});

