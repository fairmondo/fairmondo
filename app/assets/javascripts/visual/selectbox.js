$(function () {

	$('select').selectBoxIt({autoWidth:false});
	parents = $('select').parent();

	parents.css("overflow", "visible");
	parents.parents().css("overflow", "visible");


});