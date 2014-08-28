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


errorTooltip = ->
  $(".inline-errors").each (index, element) ->
    document.Fairnopoly.setQTipError element

document.Fairnopoly.setQTipError = (element) ->
  $error = $(element)
  $input = $error.siblings('input') #TODO find more form elements
  $input.qtip
    content:
      text: $error
    style:
      classes: 'qtip-red qtip-rounded qtip-shadow'
    position:
      viewport: $(window)
    show:
      event: false
      ready: true
    hide:
      target: $input
      event: 'focus'
      fixed: false

$(document).ready errorTooltip
