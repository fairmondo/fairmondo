tooltip = ->
  $("span.sprite_helper, .Qtip").qtip
    content:
      text: false
    style:
      classes: 'qtip-light'
    position:
      viewport: $(window)
    show: 'click'
    hide: 'unfocus'

$(document).ready tooltip
$(document).ajaxStop tooltip
$(document).on 'socialshareprivacyinserted', tooltip

document.Fairnopoly.setQTipError = ->
  $(".inline-errors").hide()
  $(".inline-errors").each (index, element) ->
    error = $(element).text()
    input = $(this.parentNode) #TODO find more form elements
    input.qtip
      content:
        text: error
        button: 'Close'
      style:
        classes: 'qtip-red qtip-rounded qtip-shadow'
      position:
        at: 'bottom left'
      show:
        event: false
        ready: true
      hide:
        target: false
        event: 'click'
        fixed: false

$(document).ready document.Fairnopoly.setQTipError
$(document).ajaxComplete document.Fairnopoly.setQTipError
