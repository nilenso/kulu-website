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
      auth: {}
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

  deleteUser: function (user) {
    var index, users;
    index = this.state.users.indexOf(user);

    users = React.addons.update(this.state.users, {
      $splice: [[index, 1]]
    });

    return this.setState({
      users: users
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
           React.DOM.th(null, 'Role'),
           React.DOM.th(null, 'Actions'))),
         React.DOM.tbody(null, (function () {
           var i, len, ref, results;
           ref = this.state.users;
           results = [];
           for (i = 0, len = ref.length; i < len; i++) {
             user = ref[i];
             results.push(React.createElement(User, {
               key: i,
               user: user,
               auth: this.props.auth,
               handleDeleteUser: this.deleteUser
            }));
        }
        return results;
      }).call(this))));
  }
});

module.exports = Users;
