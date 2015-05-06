var Admin = React.createClass({
  submitInvitation: function (e) {
    e.preventDefault();

    var email = this.refs["email"].getDOMNode().value;

    $.post('/invite', {
      token: this.props.token,
      organization_name: this.props.organization_name,
      user_email: email
    })
  },

  render: function () {
    return (<div className="invite">
      <div>
        <h3>Invite new team members</h3>

        <p>
          <ul>
            <li>Members you invite will be able to see all their expenses</li>
            <li>Accountants can manage all your expenses</li>
          </ul>
        </p>
      </div>

      <form className="invite-form">
        <h4>Add new</h4>
        <input ref="email" className="invite-form-input"
               placeholder="Email" type="email" pattern=".*@.*\..*" required/>
        <button type="submit" className="invite-form-button" id="submit" onClick={this.submitInvitation}>+</button>
      </form>
    </div>);
  }
});
