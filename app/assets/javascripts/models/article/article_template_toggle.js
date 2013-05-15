
// refs #128

$(document).ready(function(){
	$("#article_template_save_as_template")
		.change(function () {
			box = $(this);
			$("#article_template_name_input").toggle(box.is(":checked"));
		}).trigger('change')
});
