var Admin = React.createClass({
  submitInvitation: function () {
    
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
