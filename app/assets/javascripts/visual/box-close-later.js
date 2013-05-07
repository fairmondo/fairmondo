
$(document).ready(function(){
	/*
	 *  Already open boxes
	 * refs #224
	 *
	 */
	if(window.location.hash) {
		$(".box-open").addClass('box').removeClass('box-open');
	}

	$(".box-legend a").click(function(event){
		$(".box-open").addClass('box').removeClass('box-open');

	});

});