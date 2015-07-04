$(document).ready(function () {
  var displayDatepicker = function (callback) {
    var input = $('.search_facet.is_editing input.search_facet_input');

    var removeDatepicker = function () {
      picker.hide();
    };

    var setVisualSearch = function (date) {
      removeDatepicker();
      // pikaday doesn't appear to return the formatted date onSelect
      // so we're having to format it manually
      callback([$.datepicker.formatDate('yy-mm-d', date)]);
      $("ul.VS-interface:visible li.ui-menu-item a:first").click()
    };

    var picker = new Pikaday({
      field: input[0],
      format: 'YYYY-MM-DD',
      onSelect: setVisualSearch,
      onClose: removeDatepicker
    });

    picker.show();
  };

  var visualSearch = VS.init({
    container: $('.visual_search'),
    query: '',
    callbacks: {
      search: function (query, searchCollection) {
      },

      facetMatches: function (callback) {
        callback([
          {label: 'query', category: 'general'},
          {label: 'merchant name', category: 'general'},
          {label: 'type', category: 'general'},
          {label: 'status', category: 'general'},
          {label: 'conflict', category: 'general'},
          {label: 'spender', category: 'general'},
          {label: 'category', category: 'general'},
          {label: 'expense date (from)', category: 'expense date'},
          {label: 'expense date (to)', category: 'expense date'},
          {label: 'submission date (from)', category: 'submission date'},
          {label: 'submission date (to)', category: 'submission date'},
          {label: 'currency', category: 'amount'},
          {label: 'amount (>)', category: 'amount'},
          {label: 'amount (<)', category: 'amount'},
          {label: 'amount (=)', category: 'amount'}
        ], {preserveOrder: true});
      },

      valueMatches: function (facet, searchTerm, callback) {
        switch (facet) {
          case 'submission date (to)':
            setTimeout(function () {
              displayDatepicker(callback)
            }, 0);
            break;
          case 'submission date (from)':
            setTimeout(function () {
              displayDatepicker(callback)
            }, 0);
            break;
          case 'expense date (to)':
            setTimeout(function () {
              displayDatepicker(callback)
            }, 0);
            break;
          case 'expense date (from)':
            setTimeout(function () {
              displayDatepicker(callback)
            }, 0);
            break;
          case 'conflict':
            callback(['No', 'Yes'], {preserveOrder: true});
            break;
          case 'type':
            callback(['Company', 'Reimbursement'], {preserveOrder: true});
            break;
          case 'status':
            callback(['Submitted', 'Extracted', 'Recorded', 'Reimbursed/Deducted', 'Reviewed'], {preserveOrder: true});
            break;
          case 'currency':
            callback(['CAD', 'USD', 'INR'], {preserveOrder: true});
            break;
        }
      }
    }
  });

  var visualSearchToApiMappings = {
    "merchant name": "name",
    "expense date (from)": "from_date",
    "expense date (to)": "to_date",
    "submission date (from)": "from_submission_date",
    "submission date (to)": "to_submission_date",
    "amount (>)": "min_amount",
    "amount (<)": "max_amount",
    "amount (=)": "amount",
    "type": "expense_type",
    "text": "q",
    "query": "q"
  };

  var formContainer = $('#search-form');
  var searchButton  = $("#expenses-search");

  searchButton.click(function (e) {
    e.preventDefault();
    return formSubmit();
  });

  var formSubmit = function () {
    _.each(visualSearch.searchQuery.facets(), function (o) {
      var key =   _.keys(o)[0];
      var value = _.values(o)[0];
      var formKeyName = visualSearchToApiMappings[key];
      input = 'input[name="' + (formKeyName ? formKeyName : key) + '"]';
      formContainer.find(input).val(value);
    });

    return formContainer.submit();
  };
});
