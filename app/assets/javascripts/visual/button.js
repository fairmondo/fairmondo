


icheck = function() {
	$("input[type=checkbox]").iCheck();
	$("input[type=radio]").iCheck();
};

$(document).ready(icheck);

$(document).ajaxStop(icheck);

