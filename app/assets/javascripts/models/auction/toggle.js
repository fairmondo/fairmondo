
// refs #151

$(document).ready(function(){
	$("input[data-select-toggle][type=checkbox]")
		.change(function () {
			box = $(this);
			area_id = box.attr("data-select-toggle");
			$("#" + area_id).toggle(box.is(":checked"));
		}).trigger('change')
	
	$("input[data-select-toggle][type=radio]")
		.change(function (e) {
			box = $(this);
			area_id = box.attr("data-select-toggle");
			$("#" + area_id).toggle(box.is(":checked"));
			if(e.isTrigger == undefined) {
			  $("input[name='" + box.attr("name") + "']:not([data-select-toggle=" + area_id + "])").trigger('change');
			}
		}).trigger('change')
	
});
