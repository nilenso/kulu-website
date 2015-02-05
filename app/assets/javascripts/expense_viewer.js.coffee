class Kulu.ExpenseViewer
  constructor: (@canvasContainer, @prevElement, @nextElement, @pageNumElement, @pageCountElement) ->
    @canvas = @canvasContainer.find('canvas')
    @loadingIcon = @canvasContainer.find('.loading-icon')
    @ctx = @canvas[0].getContext("2d");
    @mimeType = @canvas.data("mime-type");

  view: (file) =>
    @file = file

    if (@mimeType == 'image/png' or @mimeType == 'image/jpeg')
      @viewImage()
    else
      if (@mimeType == 'application/pdf')
        @viewPDF()

  viewImage: =>
    @canvasContainer.hide()
    $('.expense-pager').hide()

    $('.expense-image').css('display', 'block').parent().zoom({
      magnify: 1
      callback: ->
        $(this).colorbox({
          href: this.src,
          onLoad: ->
              $('#cboxClose').remove()
          })
    });

  viewPDF: =>
    $('.expense-image-container').hide()
    @loadingIcon.show()
    ###*
    Get page info from document, resize canvas accordingly, and render page.
    @param num Page number.
    ###
    renderPage = (num) =>
      pageRendering = true

      # Using promise to fetch the page
      pdfDoc.getPage(num).then (page) =>
        viewport = page.getViewport(scale)
        @canvas[0].height = viewport.height
        @canvas[0].width = viewport.width

        # Render PDF page into canvas context
        renderContext =
          canvasContext: @ctx
          viewport: viewport

        renderTask = page.render(renderContext)

        # Wait for rendering to finish
        renderTask.then =>
          @loadingIcon.hide()
          @canvas.show()
          pageRendering = false
          if pageNumPending isnt null

            # New page rendering is pending
            renderPage(pageNumPending)
            pageNumPending = null

      # Update page counters
      document.getElementById(@pageNumElement).textContent = pageNum

    ###*
    If another page rendering in progress, waits until the rendering is
    finised. Otherwise, executes rendering immediately.
    ###
    queueRenderPage = (num) ->
      if pageRendering
        pageNumPending = num
      else
        renderPage(num)

    ###*
    Displays previous page.
    ###
    onPrevPage = ->
      return if pageNum <= 1
      pageNum--
      queueRenderPage(pageNum)

    ###*
    Displays next page.
    ###
    onNextPage = ->
      return if pageNum >= pdfDoc.numPages
      pageNum++
      queueRenderPage(pageNum)

    PDFJS.disableWorker = true

    pdfDoc = null
    pageNum = 1
    pageRendering = false
    pageNumPending = null
    scale = 0.9
    document.getElementById(@prevElement).addEventListener "click", onPrevPage
    document.getElementById(@nextElement).addEventListener "click", onNextPage

    ###*
    Asynchronously downloads PDF.
    ###
    PDFJS.getDocument(@file)
      .then(
        (pdfDoc_) =>
          pdfDoc = pdfDoc_
          document.getElementById(@pageCountElement).textContent = pdfDoc.numPages
          # Initial/first page rendering
          renderPage(pageNum)
        , ->
            # FIXME: Chrome throws CORS issues when page is reached from the table
            # But on page refresh, the pdf is rendered properly. We should move to a solution
            # where pdf is streamed from our server to get around CORS.
            window.location.reload())
