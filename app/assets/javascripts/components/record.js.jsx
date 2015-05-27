var React = require('react');

var amountFormat;

amountFormat = function (amount) {
  return '$ ' + Number(amount).toLocaleString();
};

var Record = React.createClass({
  getInitialState: function () {
    return {
      edit: false
    };
  },

  handleToggle: function (e) {
    e.preventDefault();
    return this.setState({
      edit: !this.state.edit
    });
  },

  handleDelete: function (e) {
    var self = this;
    e.preventDefault();

    return $.ajax({
      method: 'DELETE',
      url: "/categories/" + this.props.record.id,
      data: {
        token: this.props.auth.token,
        organization_name: this.props.auth.organization_name
      },
      dataType: 'JSON'
    }).success(function () {
        return self.props.handleDeleteRecord(self.props.record);
      }
    );
  },

  handleEdit: function (e) {
    var self = this;
    e.preventDefault();

    var sendData = {
      name: React.findDOMNode(this.refs.name).value
    };

    return $.ajax({
      method: 'PUT',
      url: "/categories/" + this.props.record.id,
      dataType: 'JSON',
      data: {
        token: this.props.auth.token,
        organization_name: this.props.auth.organization_name,
        name: sendData.name
      }
    }).success(function () {
        self.setState({edit: false});
        return self.props.handleEditRecord(self.props.record, sendData);
      }
    );
  },

  recordRow: function () {
    return React.DOM.tr(null, React.DOM.td(null, this.props.record.name), React.DOM.td(null, React.DOM.a({
      className: 'btn btn-default',
      onClick: this.handleToggle
    }, 'Edit'), React.DOM.a({
      className: 'btn btn-danger',
      onClick: this.handleDelete
    }, 'Delete')));
  },

  recordForm: function () {
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

  render: function () {
    if (this.state.edit) {
      return this.recordForm();
    } else {
      return this.recordRow();
    }
  }
});

module.exports = Record;
