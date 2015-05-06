var InviteUser = React.createClass({
  render: function () {
    return (<div>
      <form className="invite-form">
        <input ref="email" className="invite-form-input"
               placeholder="Email" type="email" pattern=".*@.*\..*" required />
        <button type="submit" className="invite-form-button" id="submit">+</button>
      </form>
    </div>);
  }
});
