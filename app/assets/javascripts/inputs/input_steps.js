// refs #109 and #154
// class "icon-minus" for categories with checked sub-categories
$(document).ready(function(){
	default_inputs = $(".box.default-step")
	erroneous_inputs = $(".box.error-box")

	if(default_inputs.size() > 0 && erroneous_inputs.size() == 0) {
	  if(window.location.hash === "") {
	  	default_input = default_inputs.first()
	    window.location.replace("#"+default_input.attr('id'))
	  }
	}

	if(erroneous_inputs.size() > 0) {
	  window.location.replace("#"+erroneous_inputs.first().attr('id'))
	}
});

function scrollToNextStep(prev_step, next_step, height) {

  if(next_step.length && prev_step != next_step){

    if (prev_step.length) {
    	if(prev_step.position().top < next_step.position().top) {
    		scroll_to = next_step.position().top - prev_step.height() + 40
    	} else {
	    	scroll_to = next_step.position().top;
    	}
    } else {
    	scroll_to = window.pageYOffset + height;
    }

    if (prev_step.hasClass("error-box")) {
      prev_step.removeClass("error-box")
      prev_step.addClass("error-box-visited")
    }

 	  window.setTimeout(function() {
	    y = window.pageYOffset;
      window.location.replace("#" + next_step.attr("id"));
	    window.scrollTo(0,y);
    },2)

    $('html,body').animate({scrollTop:scroll_to},'slow');

    // fix for chrome rendering issues, see #165
    // the background is not completely white (1 less rgb), else
    // it does not trigger chrome to redraw
    //
    // Note: apparently not required after swichting to position+negative top solution, see box.less
    // if (window.chrome) {
	  //   box_to_show = next_step.find(".box-content");
	  //   box_to_show.css("background-image","url('/assets/back-white.png')");
    // }
  }
}

/* tryout to calculate next position by iterating
$(document).ready(function(){
	steps = $('.box-legend a[href^=#]')
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
		$('.box-legend a[href^=#]').on("click",function(e){
		    e.preventDefault();
		    prev_step = $(window.location.hash);
		    next_step = $(this.hash);
		    next_step = next_step.length && next_step || $('[name='+this.hash.slice(1)+']');
		    height = $(this).closest(".box-legend").height();
		    scrollToNextStep(prev_step, next_step, height);
		});
	});
}
