$(function() {

	setTimeout(function(){
		$('.Notice--info').addClass('is-hidden');
		$('.Notice--error').addClass('is-hidden');
	}, 5000);

	$('.Notice-close').on('click', function(){
		$(this).parent().parent().addClass('is-hidden');
	})
	//$('.Notice').delay(5000).addClass('is-hidden');

});