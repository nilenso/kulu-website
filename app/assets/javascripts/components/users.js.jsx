var React = require('react/addons');
var User = require('./user.js.jsx');
var LoadingIcon = require('./loading-icon.js.jsx');

var Users = React.createClass({
  getInitialState: function () {
    return {
      users: []
    };
  },

  getDefaultProps: function () {
    return {
      auth: {},
      data: {}
    };
  },

  listUsers: function () {
    var self = this;

    $.get('/users', {}).fail(function (e) {
      console.log(e);
    }).success(function (d) {
      self.setState({users: d});
    });
  },

  componentWillMount: function () {
    this.listUsers();
  },

  render: function () {
    var user;

    if (!this.state.users) {
      return <LoadingIcon/>
    }

    return React.DOM.div({
      className: 'users'
      },
      React.DOM.table({
        className: 'table table-bordered'
      }, React.DOM.thead(null,
           React.DOM.tr(null,
           React.DOM.th(null, 'Email'),
           React.DOM.th(null, 'Status'),
           React.DOM.th(null, 'Role'))),
         React.DOM.tbody(null, (function () {
           var i, len, ref, results;
           ref = this.state.users;
           results = [];
           for (i = 0, len = ref.length; i < len; i++) {
             user = ref[i];
             results.push(React.createElement(User, {
               key: i,
               user: user,
               auth: this.props.auth
            }));
        }
        return results;
      }).call(this))));
  }
});

module.exports = Users;
