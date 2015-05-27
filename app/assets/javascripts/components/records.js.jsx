var React = require('react');
var RecordForm = require('./record_form.js.jsx');
var Record = require('./record.js.jsx');

var Records = React.createClass({
  getInitialState: function() {
    return {
      records: this.props.data
    };
  },

  getDefaultProps: function() {
    return {
      records: []
    };
  },

  addRecord: function(record) {
    var records;
    records = React.addons.update(this.state.records, {
      $push: [record]
    });
    return this.setState({
      records: records
    });
  },

  deleteRecord: function(record) {
    var index, records;
    index = this.state.records.indexOf(record);
    records = React.addons.update(this.state.records, {
      $splice: [[index, 1]]
    });
    return this.replaceState({
      records: records
    });
  },

  updateRecord: function(record, data) {
    var index, records;
    index = this.state.records.indexOf(record);
    records = React.addons.update(this.state.records, {
      $splice: [[index, 1, data]]
    });
    return this.replaceState({
      records: records
    });
  },

  render: function() {
    var record;
    return React.DOM.div({
      className: 'records'
    }, React.createElement(RecordForm, {
      handleNewRecord: this.addRecord
    }), React.DOM.hr(null), React.DOM.table({
      className: 'table table-bordered'
    }, React.DOM.thead(null, React.DOM.tr(null, React.DOM.th(null, 'Name'), React.DOM.th(null, 'Actions'))), React.DOM.tbody(null, (function() {
      var i, len, ref, results;
      ref = this.state.records;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        record = ref[i];
        results.push(React.createElement(Record, {
          key: record.id,
          record: record,
          handleDeleteRecord: this.deleteRecord,
          handleEditRecord: this.updateRecord
        }));
      }
      return results;
    }).call(this))));
  }
});

module.exports = Records;
