$(document).ready(function(){
	$(".Image-titleinput").on("ifChecked", function(event) {

		$(".Image-titleinput").not(event.target).iCheck('uncheck');
	});
});
