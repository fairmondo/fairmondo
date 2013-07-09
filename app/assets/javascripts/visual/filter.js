//
// Filter
//

var togglefilter = function(event){
		event.preventDefault();

		filter.toggleClass('is-active');
		filter.find(".Filter-inner").css("overflow","hidden");
	}

$(function() {

	filter = $('.Filter');
	filterToggle = $('#js-filter-toggle');

	filterToggle.click(togglefilter);

	inputToggele = $('#search_input');
	inputToggele.focus(function(event) {
		filter.addClass('is-active');
	});



});

