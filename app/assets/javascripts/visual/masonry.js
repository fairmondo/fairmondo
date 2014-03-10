//
// Packery
//

$(function(){
  var $container = $('.Grid-mansory');
  if ($container.length > 0) {
    $container.prepend('<div class="gutter-sizer"></div><div class="grid-sizer"></div>');
    $container.imagesLoaded( function() {
      $container.masonry({
        itemSelector: '.Grid',
        gutter: '.gutter-sizer',
        columnWidth: '.grid-sizer'
      });
    });
  }

  var $articles = $('.l-ArticleList');
  if ($articles.length > 0) {
    $articles.prepend('<div class="gutter-sizer"></div><div class="grid-sizer"></div>');
    $articles.imagesLoaded( function() {
      $articles.masonry({
        itemSelector: '.Grid',
        gutter: '.gutter-sizer',
        columnWidth: '.grid-sizer'
      });
    });
  }
});