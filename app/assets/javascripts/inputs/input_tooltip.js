$(document).ready(function(){
	$("a.input-tooltip").click(function (e) {
	  open_class = "open-tooltip";
	  closed_class = "closed-tooltip";
	  is_open = $(this).hasClass(open_class);
	  	  
	  $("."+open_class).removeClass(open_class);
	  
	  if (! is_open) {
	    $(this).addClass(open_class);
	    $("a.input-tooltip:not(."+open_class+")").addClass(closed_class)	    
	  } else {
	    $("a.input-tooltip").removeClass(closed_class);
	    $(this).addClass(closed_class);
	    $(this).one("mouseout",function (e) {
	      $(this).removeClass(closed_class);
	    });
	  }
	});
});