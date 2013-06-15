$(function() {
	target = 0;
	if(window.location.hash){
		target = $(window.location.hash).index()
	}
	$(".Accordion").accordion({ header: "a.Accordion-header",heightStyle: "content" , collapsible:true , active: false});
	$(".Accordion--activated").accordion({ header: "a.Accordion-header",heightStyle: "content" , active: target , collapsible:true});
	
});

