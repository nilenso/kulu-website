class Kulu.InplaceEdit
  constructor: (@formContainer) ->
    @fieldsets = @formContainer.find(".inplace-edit-fieldset")
    @updateButton = @formContainer.find(".invoice-details-submit")
    @invoiceID = @formContainer.find('input[name="invoice-id"]').val()

    @setupFieldsets()

    @updateButton.click (e) =>
      e.preventDefault()
      @formSubmit()

  setupFieldsets: () =>
    _.each @fieldsets, (fieldset) =>
      showField = $(fieldset).find(".inplace-edit-show")

      showField.click =>
        showField.hide()
        @updateButton.show()
        $(fieldset).find(".inplace-edit-input").show()

  formSubmit: () =>
    data = {
      name: @formContainer.find('input[name="invoice[:name]"]').val()
      currency: @formContainer.find('select[name="invoice[:currency]"]').val()
      amount: Number(@formContainer.find('input[name="invoice[:amount]"]').val())
      date: @formContainer.find('input[name="invoice[:date]"]').val()
    }

    $.ajax(
      type: "PUT"
      url: Routes.invoice_path({id: @invoiceID})
      data: JSON.stringify({invoice: data})
      contentType: "application/json"
    ).success -> alert "Data Saved."