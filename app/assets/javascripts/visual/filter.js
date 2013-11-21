//
// Filter
//

var toggleFilter = function(event){
  event.preventDefault();

  var $filter = $('.Filter');
  $filter.toggleClass('is-active');
  $filter.find(".Filter-inner").css("overflow","hidden");
};

$(function() {
  var $filterToggle = $('.js-filter-toggle');
  var $inputToggle = $('#search_input');

  $filterToggle.click(toggleFilter);
  $inputToggle.focus(function() {
    var $filter = $('.Filter');
    $filter.addClass('is-active');
  });

  // disable defaultly displayed advanced search box for mobile width
  if ($(window).width() < 680)
    $('.Hero-search .Filter').removeClass('is-active');
});
