$(function() {
    function sources(request, response){
	  	var params = {keywords: request.term};
	  	return $.get(jQuery("#search_input").attr('data-autocomplete'), params, function(data){ response(data); }, "json");
	}

	$( "#search_input" ).autocomplete({
	      source: sources
	});

 });