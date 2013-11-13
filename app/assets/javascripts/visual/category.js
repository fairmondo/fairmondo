$(function() {
	$("#show-all-categories").hover(function() {
		$(".Hero-categories").css("height","100%");
		$(".HeaderArea").mouseleave(function() { $(".Hero-categories").css("height","2em"); });
	});
});