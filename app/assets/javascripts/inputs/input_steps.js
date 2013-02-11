// refs #109 and #154
// class "icon-minus" for categories with checked sub-categories
$(document).ready(function(){
	default_input = $(".input-step.default-step").first()
	
	if(default_input != undefined && window.location.hash === "") {
	  window.location.hash = default_input.attr('id')
	}
});
