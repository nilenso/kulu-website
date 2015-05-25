var React = require('react');
var Tabs = require('react-simpletabs');

var Admin = React.createClass({
  getInitialState: function (e) {
    return {
      users: []
    }
  },

  submitInvitation: function (e) {
    e.preventDefault();

    var self = this;
    var email = this.refs["email"].getDOMNode().value;

    $.post('/invite', {
      token: this.props.token,
      organization_name: this.props.organization_name,
      user_email: email
    }).fail(function (e) {
      Turbolinks.visit(self.props.admin_root_path);
      Kulu.flash();
    }).success(function () {
      Turbolinks.visit(self.props.admin_root_path);
      Kulu.flash();
    });
  },

  handleBefore: function(selectedIndex, $selectedPanel, $selectedTabMenu) {
    if (selectedIndex === 2) {
      this.listUsers();
    }
  },

  listUsers: function () {
    var self = this;

    $.get('/users', {
      token: this.props.token,
      organization_name: this.props.organization_name
    }).fail(function (e) {
      console.log(e);
    }).success(function (e) {
      self.setState({users: e, activeTab: 2});
    });
  },

  render: function () {
    return (<div className="invite">
      <Tabs onBeforeChange={this.handleBefore} tabActive={this.state.activeTab}>
        <Tabs.Panel title='Invite'>
          <div>
            <h3>Invite new team members</h3>

            <p>
              <ul>
                <li>Members you invite will be able to see all the expenses of the company</li>
              </ul>
            </p>
          </div>

          <form className="invite-form">
            <h4>Add new</h4>
            <input ref="email" className="invite-form-input"
                   placeholder="Email" type="email" pattern=".*@.*\..*" required/>
            <button type="submit" className="btn btn-primary invite-form-button" id="submit"
                    onClick={this.submitInvitation}>Send
            </button>
          </form>
        </Tabs.Panel>

        <Tabs.Panel title='Users'>
          <div>
            <h3>Active users</h3>

            <p>
              <ul>
                {
                  this.state.users.map(function(o, i) {
                    return <li key={i}>{o["user-email"]} ({o["role"]})</li>;
                  })
                }
              </ul>
            </p>
          </div>

        </Tabs.Panel>

        <Tabs.Panel title='Support'>
          <h3>Reach out to us</h3>
          <p>If you're facing any issues in using Kulu, feel free to drop us a <a href="mailto:kulu@nilenso.com" target="_top">mail</a>.
            Or call us at <a href="tel:+918553427344">+91 8553 427 344</a></p>
        </Tabs.Panel>
      </Tabs>
    </div>);
  }
});

module.exports = Admin;
