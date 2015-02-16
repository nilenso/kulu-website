class Kulu.FixTopTableHeader
  constructor: (@table, @offsetHeight) ->
    tableHead = @table.find('thead')
    $(window).scroll =>
      if $(window).scrollTop() >= (tableHead.position().top - @offsetHeight)
        tableHead.css('position', 'fixed')
        tableHead.css('top', @offsetHeight)
      else
        tableHead.css('position', '')
        tableHead.css('top', '')

