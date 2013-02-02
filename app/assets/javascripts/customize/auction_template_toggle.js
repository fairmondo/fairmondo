
// refs #128

$(document).ready(function(){
	$("#auction_template_save_as_template")
		.change(function () {
			box = $(this);
			$("#auction_template_name_input").toggle(box.is(":checked"));
		}).trigger('change')
});
