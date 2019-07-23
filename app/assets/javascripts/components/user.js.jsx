var React = require('react');

var User = React.createClass({
  handleDelete: function (e) {
    var self = this;
    e.preventDefault();

    if (!window.confirm("Are you sure?")) {
        e.stopPropagation();
    return false;
    }

    return $.ajax({
        method: 'DELETE',
        url: "/users/" + this.props.user["id"],
        dataType: 'JSON'
    }).success(function () {
        return self.props.handleDeleteUser(self.props.user);
        });
    },

  recordRow: function () {
    return React.DOM.tr(null,
                        React.DOM.td(null, this.props.user["user-email"]),
                        React.DOM.td(null, this.props.user["role"]),
                        React.DOM.td(null, React.DOM.a({
                            className: 'btn btn-danger',
                            onClick: this.handleDelete
                        }, React.DOM.i({className: 'fa fa-trash-o'}))));
  },

  render: function () {
    return this.recordRow();
  }
});

module.exports = User;
