//
// Packery
//

$(function(){
  var $container = $('.Grid-mansory');
  if ($container.length > 0) {
    $container.prepend('<div class="Category-GutterSizer"></div><div class="Category-GridSizer"></div>');
    $container.imagesLoaded( function() {
      $container.masonry({
        itemSelector: '.Category-Grid',
        gutter: '.Category-GutterSizer',
        columnWidth: '.Category-GridSizer'
      });
    });
  }

  var $articles = $('.l-ArticleList');
  if ($articles.length > 0) {
    $articles.prepend('<div class="Search-GutterSizer"></div><div class="Search-GridSizer"></div>');
    $articles.imagesLoaded( function() {
      $articles.masonry({
        itemSelector: '.Search-Grid',
        gutter: '.Search-GutterSizer',
        columnWidth: '.Search-GridSizer'
      });
    });
  }
});