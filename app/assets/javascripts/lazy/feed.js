$(function() {
	if ($("#Feed-placeholder").length != 0) {
		$.get( "/toolbox/rss", function( data ) {
  			$( "#Feed-placeholder" ).html( data );
  			$('#js-masonry').masonry();
		});
	}
});
