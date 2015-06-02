var React = require('react');

var app = {
  listener: null,

  nextId: 3,

  rows: [
    {id: 1, name: "entry 1"},
    {id: 2, name: "entry 2"}
  ],

  focusedId: 1,

  addRow: function () {
    var id = this.nextId++;
    this.rows.push({id: id, name: ("entry " + id)});
    this.setFocusedId(id);
  },

  getName: function(id){
    return _.findWhere(this.rows, {id: id}).name;
  },

  updateName: function (name) {
    var id = this.focusedId;
    _.findWhere(this.rows, {id: id}).name = name;
    this.listener.changed();
  },

  setFocusedId: function (id) {
    this.focusedId = id;
    this.listener.changed();
  }
};

var Row = React.createClass({
  render: function () {
    if (this.props.focused) {
      return <span>Value: {this.props.name} [editing]</span>;
    } else {
      return <span>
      Value: {this.props.name}
        [<a href='#' onClick={this.props.focus}>edit</a>]
      </span>;
    }
  }
});

var CategoryView = React.createClass({
  getInitialState: function () {
    return {
      app: app,
      color: '#bada55'
    };
  },

  componentWillMount: function () {
    this.state.app.listener = this;
  },

  changed: function () {
    this.forceUpdate();
  },

  handleChange: function (color) {
    this.setState({ color : color });
  },

  textChanged: function (event) {
    this.state.app.updateName(event.target.value);
  },

  render: function () {
    var self = this;
    var app = this.state.app;

    var rows = _.map(app.rows, function (row) {
      var focus = function () {
        app.setFocusedId(row.id);
      };

      return <li key={row.id}>
        <ColorPicker color={self.state.color} onChange={this.handleChange} />

        <Row
          name={row.name}
          focused={row.id == app.focusedId}
          focus={focus}
          />
      </li>;
    });

    return <div>
      EDIT:
      <input
        type="text"
        value={app.getName(app.focusedId)}
        onChange={this.textChanged}
        />
      <ul>{rows}</ul>
      <a href="#"
         onClick={function(){app.addRow()}}>
        add row
      </a>
    </div>;
  }
});

module.exports = CategoryView;
