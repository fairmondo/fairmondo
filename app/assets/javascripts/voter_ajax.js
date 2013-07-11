$(function() {
	$('form[data-update-target]').live('ajax:success', function(evt, data) {
		var target = $(this).data('votes');
	$('#' + target).html(data);
	});
});