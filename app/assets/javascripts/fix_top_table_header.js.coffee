class Kulu.FixTopTableHeader
  constructor: (@table, @offsetHeight) ->
    tableHead = @table.find('thead')
    tableHeadPosition = tableHead.position().top
    $(window).scroll =>
      console.log("Table " + tableHeadPosition)
      if $(window).scrollTop() >= (tableHeadPosition - @offsetHeight)
        tableHead.css('position', 'fixed')
        tableHead.css('top', @offsetHeight)
      else
        tableHead.css('position', '')
        tableHead.css('top', '')

