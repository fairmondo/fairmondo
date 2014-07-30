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
