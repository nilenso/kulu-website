class Kulu.Utils
  clickableRows: (invoiceRows) ->
    _.each invoiceRows, (invoiceRow) ->
      $(invoiceRow).click ->
        window.location.href = $(this).data('invoice-url')
