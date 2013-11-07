$(function() {
	if ($("#Teaser-news-placeholder").length != 0) {
		$.get( "/toolbox/rss", function( data ) {
  			$( "#Teaser-news-placeholder" ).html( data );
  			$("#Teaser-news-placeholder").removeClass("Teaser-hide");
		});
	}
});
