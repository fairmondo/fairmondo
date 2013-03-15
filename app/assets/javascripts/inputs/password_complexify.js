
$(document).ready(function(){
	$("#user_password").complexify( {strengthScaleFactor: 0.5} , function (valid, complexity) {
			$("#password_complexity_progress").show();
			var bar = $("#password_complexity_progress .bar")
	    	bar.width( complexity + "%" );
	    	if(valid) {
	    		bar.addClass("bar-success").removeClass("bar-danger");
	    	} else {
	    		bar.addClass("bar-danger").removeClass("bar-success");
	    	}
	});
});

