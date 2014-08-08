class Kulu.Paginator
  constructor: (form) ->
    @form = form

  setupPerPageForm: ->
    $(@form.find('input#per-page')).change ->
      @form.submit()
