$(function() {

	setTimeout(function(){
		$('.Notice--info').addClass('is-hidden');
	}, 10000);

	$('.Notice').on('click','.Notice-close', function(){
		$(this).parent().parent().addClass('is-hidden');
	})
	//$('.Notice').delay(5000).addClass('is-hidden');

});