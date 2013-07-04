$(function() {

	setTimeout(function(){ 
		$('.Notice').addClass('is-hidden'); 
		console.log('hide me');
	}, 5000);

	$('.Notice-close').on('click', function(){
		$('.Notice').addClass('is-hidden');
	})
	//$('.Notice').delay(5000).addClass('is-hidden');

});