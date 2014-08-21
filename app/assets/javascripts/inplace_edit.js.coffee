class Kulu.InplaceEdit
  constructor: (formContainer) ->
    @fieldsets = formContainer.find(".inplace-edit-fieldset")
    @updateButton = formContainer.find(".invoice-details-submit")
    this.setupFieldsets()

  setupFieldsets: () =>
    _.each @fieldsets, (fieldset) =>
      showField = $(fieldset).find(".inplace-edit-show")
      showField.click =>
        showField.hide()
        @updateButton.show()
        $(fieldset).find(".inplace-edit-input").show()