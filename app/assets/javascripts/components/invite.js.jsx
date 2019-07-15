var React = require('react');
var Users = require('./users.js.jsx');

var Invite = React.createClass({
  getDefaultProps: function () {
    return {
      auth: {}
    };
  },

  submitInvitation: function (e) {
    e.preventDefault();

    var self = this;
    var email = this.refs["email"].getDOMNode().value;

    $.post('/invite', {
      user_email: email
    }).fail(function (e) {
      Turbolinks.visit(self.props.admin_root_path);
      Kulu.flash();
    }).success(function () {
      Turbolinks.visit(self.props.admin_root_path);
      Kulu.flash();
    });
  },

  render: function () {
    return (<div>
      <div>
        <h3>Invite new team members</h3>

        <p>
          <ul>
            <li>Members you invite will be able to see all the expenses of the company</li>
          </ul>
        </p>
      </div>

      <form className="invite-form form-inline">
        <div className="controls form-group">
          <input ref="email" className="form-control admin-form-input"
                 placeholder="Email" type="email" pattern=".*@.*\..*" required/>
          <button type="submit" className="btn btn-primary admin-form-button" id="submit"
                  onClick={this.submitInvitation}>Send
          </button>
        </div>
      </form>

      <div>
        <h3>All users</h3>
        <Users auth={this.props.auth}/>
      </div>
    </div>);
  }
});

module.exports = Invite;
