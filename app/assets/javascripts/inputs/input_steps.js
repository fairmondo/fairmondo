// refs #109 and #154
// class "icon-minus" for categories with checked sub-categories
$(document).ready(function(){
	default_inputs = $(".box.default-step")
	if(default_inputs.size() > 0) {
	  if(window.location.hash === "") {
	  	default_input = default_inputs.first()
	    window.location.hash = default_input.attr('id')
	  }
	}
});

function scrollToNextStep(prev_step, next_step, height) {
     
    if(next_step.length && prev_step != next_step){
	    if (prev_step.length) {
	    	if(prev_step.position().top < next_step.position().top) {
	    		scroll_to = prev_step.position().top + height;
	    	} else {
		    	scroll_to = next_step.position().top;
	    	}
	    } else {
	    	scroll_to = window.pageYOffset + height;
	    } 
	    
	 	window.setTimeout(function() {
		    y = window.pageYOffset;
	        window.location.hash = "#" + next_step.attr("id");
		    window.scrollTo(0,y);
	    },1)
	    
        $('html,body').animate({scrollTop:scroll_to},'slow');
    }
}

/* tryout to calculate next position by iterating
$(document).ready(function(){
	steps = $('.step-legend a[href^=#]')
	if(steps.length) {
		var first_step_y = steps.first().position().top  
		steps.each(function(i) {
			$(this).on("click",function(e){
			    e.preventDefault();
			    prev_step = $(window.location.hash);
			    next_step = $(this.hash);
			    next_step = next_step.length && next_step || $('[name='+this.hash.slice(1)+']');
			    height = $(this).closest(".step_legend").height();
				alert($(this).closest(".step_legend"))
			    scrollToNextStep(prev_step, next_step, height * (i + 1));
		    });
		});
	}
});
*/

if (!$.support.leadingWhitespace) {
	// your IE 7/8 code here
} else {
	$(document).ready(function(){
		$('.step-legend a[href^=#]').on("click",function(e){
		    e.preventDefault();
		    prev_step = $(window.location.hash);
		    next_step = $(this.hash);
		    next_step = next_step.length && next_step || $('[name='+this.hash.slice(1)+']');
		    height = $(this).closest(".step-legend").height();
		    scrollToNextStep(prev_step, next_step, height);
		});
	});
}
