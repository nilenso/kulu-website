class Kulu.InvoiceEdit
  constructor: (@formContainer) ->
    @fieldsets = @formContainer.find(".inplace-edit-fieldset")
    @actionsContainer = @formContainer.find(".inplace-edit-actions")
    @updateButton = @formContainer.find(".inplace-edit-submit")
    @cancelButton = @formContainer.find(".inplace-edit-cancel")
    @invoiceID = @formContainer.find('input[name="invoice-id"]').val()
    @dateGroup = @formContainer.find('.invoice-details-date-group')

    @setupFieldsets()

    @updateButton.click (e) =>
      e.preventDefault()
      @formSubmit()

    @cancelButton.click (e) =>
      e.preventDefault()
      @revertToShow()

  setupFieldsets: () =>
    _.each @fieldsets, (fieldset) =>
      showField = $(fieldset).find(".inplace-edit-show")
      showField.click =>
        showField.hide()
        @actionsContainer.show()
        $(fieldset).find(".inplace-edit-input").show()

  isDateValid: () =>
    dateInput = @dateGroup.find(".invoice-details-date")
    moment($(dateInput).val(), "DD-MM-YYYY").isValid()

  formSubmit: () =>
    unless @isDateValid()
      @dateGroup.addClass('has-error')
      return false

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
    ).success => location.reload()

  revertToShow: () =>
    @actionsContainer.hide()
    _.each @fieldsets, (fieldset) =>
      $(fieldset).find(".inplace-edit-show").show()
      $(fieldset).find(".inplace-edit-input").hide()
