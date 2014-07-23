$(document).ready ->
  resizeText = (el) ->
    title = el
    container = el.parent()
    fontSize = parseInt(title.css("font-size"))
    while title.height() > container.height()
      fontSize = fontSize - .5
      title.css "font-size", fontSize + "em"
    return

  resizeText $("#rewrite-title")

  $('textarea').autosize()
  return
