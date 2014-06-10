tooltip = ->
	$("span.sprite_helper").qtip
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
