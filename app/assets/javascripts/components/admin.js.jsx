var React = require('react');
var Tabs = require('react-simpletabs');
var Records = require('./records.js.jsx');

var Admin = React.createClass({
  getInitialState: function (e) {
    return {
      users: [],
      activeTab: 1
    }
  },

  submitInvitation: function (e) {
    e.preventDefault();

    var self = this;
    var email = this.refs["email"].getDOMNode().value;

    $.post('/invite', {
      token: this.props.auth.token,
      organization_name: this.props.auth.organization_name,
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
    if (selectedIndex == 2) {
      this.listUsers();
      this.setState({activeTab: 2});
    }
  },

  listUsers: function () {
    var self = this;

    $.get('/users', {
      token: this.props.auth.token,
      organization_name: this.props.auth.organization_name
    }).fail(function (e) {
      console.log(e);
    }).success(function (d) {
      self.setState({users: d});
    });
  },

  render: function () {
    var forwardMail = "expenses." + this.props.auth.organization_name + "@kulu.in";

    return (<div className="invite">
      <Tabs onBeforeChange={this.handleBefore} tabActive={this.state.activeTab}>
        <Tabs.Panel title='Categories'>
          <h4>Add new</h4>
          <Records auth={this.props.auth}/>
        </Tabs.Panel>

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

        <Tabs.Panel title='Receipts'>
          <div className='mail-receipt-container'>
            <div className="receipt-icon"><i className="fa fa-envelope-o"></i></div>
            <h5>
              Forward your inbox receipts to <a href="mailto:{forwardMail}" target="_top">{forwardMail}</a><br/> using your account email.
            </h5>
            <br/>
            <h5>
              We'll process them and put them in Kulu.
            </h5>
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
