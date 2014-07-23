class Kulu.FileUploader
  constructor: (form) ->
    @form = form
    @fileNameInput = form.find('input#filename')
    @fileInput = form.find('input#file-upload')
    @url = @fileInput.data('s3-url')
    @formData = @fileInput.data('form-data')

  setupUpload: ->
    @fileInput.fileupload
      fileInput: @fileInput
      url: @url
      type: "POST"
      autoUpload: true
      formData: @formData
      paramName: "file" # S3 does not like nested name fields i.e. name="user[avatar_url]"
      dataType: "XML" # S3 returns XML if success_action_status is set to 201
      replaceFileInput: false
      done: (e, data) =>
        @form.submit()

      fail: (e, data) ->
        alert("Wowoow! Shit is broken!")
