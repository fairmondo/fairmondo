
// refs #151

$(document).ready(function(){
	$("input[data-select-toggle][type=checkbox]")
		.change(function () {
			box = $(this);
			area_id = box.attr("data-select-toggle");
			$("#" + area_id).toggle(box.is(":checked"));
		}).trigger('change')

	if (!$.support.leadingWhitespace) { // IE 7 / 8 version
		$("input[data-select-toggle][type=radio]")
			.change(function (e) {
				box = $(this);
				area_id = box.attr("data-select-toggle");
				boxes_for_other_areas = $("input[data-select-toggle][type=radio]")

				boxes_for_other_areas.each(function(i) {
					other_box = $(this);
					if (! other_box.attr("checked")) {
						other_area_id = other_box.attr("data-select-toggle");
						$("#" + other_area_id).toggle(false);
					}
				});
				if (box.attr("checked")) {
					$("#" + area_id).toggle(true);
				}
			}).trigger('change');
	} else {
		$("input[data-select-toggle][type=radio]")
			.change(function (e) {
				box = $(this);
				area_id = box.attr("data-select-toggle");
				$("#" + area_id).toggle(box.is(":checked"));
				if(e.isTrigger == undefined) {
				  $("input[name='" + box.attr("name") + "']:not([data-select-toggle=" + area_id + "])").trigger('change');
				}
			}).trigger('change')
	}

});
