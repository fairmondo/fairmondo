//
// Filter
//

$(function() {
	var visible = false;
	var $filter = $('.Filter');
	var $filterToggle = $('#js-filter-toggle');

	$filterToggle.click(function(event){
		event.preventDefault();
		
		$filter.toggleClass('is-active');
		// $filter.find(".Filter-inner").css("overflow","hidden");
	});
});