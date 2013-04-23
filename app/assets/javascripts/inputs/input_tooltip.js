$(document).ready(function(){
	$("a.input-tooltip").popover({"placement" : "left",  template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><div class="popover-content"><p></p></div></div></div>'}).click(function(e) {
        e.stopPropagation();
    });

	$(window).hashchange( function(){
	    // Alerts every time the hash changes!
	   $("a.input-tooltip").popover('hide');
  	});
  	
	$('html').click(function(e) {
    	$("a.input-tooltip").popover('hide');
	});

});