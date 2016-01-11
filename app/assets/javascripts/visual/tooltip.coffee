###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

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

document.Fairmondo.setQTipError = ->
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

$(document).ready document.Fairmondo.setQTipError
$(document).ajaxComplete document.Fairmondo.setQTipError
