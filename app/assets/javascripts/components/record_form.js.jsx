var React = require('react');

var RecordForm = React.createClass({
  getInitialState: function () {
    return {name: ''};
  },

  valid: function () {
    return this.state.name;
  },

  handleChange: function (e) {
    var name, obj;
    name = e.target.name;
    return this.setState((
      obj = {},
        obj["" + name] = e.target.value,
        obj
    ));
  },

  handleSubmit: function (e) {
    var self = this;
    e.preventDefault();

    return $.post('/categories', this.state).fail(function (e) {
      Turbolinks.visit(self.props.admin_root_path);
      Kulu.flash();
    }).success(function (data) {
      self.props.handleNewRecord(data);
      return self.setState(self.getInitialState());
    });
  },

  render: function () {
    return React.DOM.form({
      className: 'form-inline',
      onSubmit: this.handleSubmit
    }, React.DOM.div({
      className: 'form-group'
    }, React.DOM.input({
      type: 'text',
      className: 'form-control',
      placeholder: 'Title',
      name: 'name',
      value: this.state.title,
      onChange: this.handleChange
    })), React.DOM.button({
      type: 'submit',
      className: 'btn btn-primary',
      disabled: !this.valid()
    }, 'Create record'));
  }
});

module.exports = RecordForm;
