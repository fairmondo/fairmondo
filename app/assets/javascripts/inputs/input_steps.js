// refs #109 and #154
// class "icon-minus" for categories with checked sub-categories
$(document).ready(function(){
	default_inputs = $(".input-step.default-step")
	if(default_inputs.size() > 0) {
	  if(window.location.hash === "") {
	  	default_input = default_inputs.first()
	    window.location.hash = default_input.attr('id')
	  }
	}
});
