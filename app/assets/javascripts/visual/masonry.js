//
// Packery
//

$(function(){

	var $container = $('#js-masonry');
	if ($container.length > 0) {
		$container.prepend('<div class="gutter-sizer"></div><div class="grid-sizer"></div>');
		$container.imagesLoaded( function() {
			$container.masonry({
				itemSelector: '.Teaser',
				gutter: '.gutter-sizer',
				columnWidth: '.grid-sizer'
			});
		});
	}

	var $articles = $('.Articles--list');
	if ($articles.length > 0) {
		$articles.prepend('<div class="gutter-sizer"></div><div class="grid-sizer"></div>');
		$articles.imagesLoaded( function() {
			$articles.masonry({
				itemSelector: '.Article',
				gutter: '.gutter-sizer',
				columnWidth: '.grid-sizer'
			});
		});
	}

});