var React = require('react');

var User = React.createClass({
  recordRow: function () {
    return React.DOM.tr(null,
                        React.DOM.td(null, this.props.user["user-email"]),
                        React.DOM.td(null, this.props.user["status"]),
                        React.DOM.td(null, this.props.user["role"]));
  },

  render: function () {
    return this.recordRow();
  }
});

module.exports = User;
