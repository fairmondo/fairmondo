$(function() {



	$('.Notice').on('click','.Notice-close', function(){
		$(this).parent().parent().addClass('is-hidden');
	});

	// Hiding notices has no use
	//$('.Notice').delay(5000).addClass('is-hidden');
	//setTimeout(function(){
	//	$('.Notice--info').addClass('is-hidden');
	//}, 10000);

});
