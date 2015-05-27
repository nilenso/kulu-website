var React = require('react');

var RecordForm = React.createClass({
  getInitialState: function () {
    return {name: ''};
  },

  valid: function () {
    return this.state.name && this.state.date && this.state.amount;
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
    e.preventDefault();
    return $.post('/categories', {
      record: this.state
    }, (function (_this) {
      return function (data) {
        _this.props.handleNewRecord(data);
        return _this.setState(_this.getInitialState());
      };
    })(this), 'JSON');
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
