var React = require('react');

var amountFormat;

amountFormat = function(amount) {
  return '$ ' + Number(amount).toLocaleString();
};

var Record = React.createClass({
  getInitialState: function() {
    return {
      edit: false
    };
  },

  handleToggle: function(e) {
    e.preventDefault();
    return this.setState({
      edit: !this.state.edit
    });
  },

  handleDelete: function(e) {
    e.preventDefault();
    return $.ajax({
      method: 'DELETE',
      url: "/records/" + this.props.record.id,
      dataType: 'JSON',
      success: (function(_this) {
        return function() {
          return _this.props.handleDeleteRecord(_this.props.record);
        };
      })(this)
    });
  },

  handleEdit: function(e) {
    var data;
    e.preventDefault();

    data = {
      name: React.findDOMNode(this.refs.name).value,
      date: React.findDOMNode(this.refs.date).value,
      amount: React.findDOMNode(this.refs.amount).value
    };

    return $.ajax({
      method: 'PUT',
      url: "/records/" + this.props.record.id,
      dataType: 'JSON',
      data: {
        record: data
      },
      success: (function(_this) {
        return function(data) {
          _this.setState({
            edit: false
          });
          return _this.props.handleEditRecord(_this.props.record, data);
        };
      })(this)
    });
  },

  recordRow: function() {
    return React.DOM.tr(null, React.DOM.td(null, this.props.record.name), React.DOM.td(null, React.DOM.a({
      className: 'btn btn-default',
      onClick: this.handleToggle
    }, 'Edit'), React.DOM.a({
      className: 'btn btn-danger',
      onClick: this.handleDelete
    }, 'Delete')));
  },

  recordForm: function() {
    return React.DOM.tr(null, React.DOM.td(null, React.DOM.input({
      className: 'form-control',
      type: 'text',
      defaultValue: this.props.record.name,
      ref: 'name'
    })), React.DOM.td(null, React.DOM.a({
      className: 'btn btn-default',
      onClick: this.handleEdit
    }, 'Update'), React.DOM.a({
      className: 'btn btn-danger',
      onClick: this.handleToggle
    }, 'Cancel')));
  },

  render: function() {
    if (this.state.edit) {
      return this.recordForm();
    } else {
      return this.recordRow();
    }
  }
});

module.exports = Record;
