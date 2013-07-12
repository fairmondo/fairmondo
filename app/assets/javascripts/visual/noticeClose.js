$(function() {

	setTimeout(function(){
		$('.Notice--info').addClass('is-hidden');
	}, 10000);

	$('.Notice-close').on('click', function(){
		$(this).parent().parent().addClass('is-hidden');
	})
	//$('.Notice').delay(5000).addClass('is-hidden');

});