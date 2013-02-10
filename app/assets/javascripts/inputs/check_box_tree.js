// refs #109 and #154
// class "icon-minus" for categories with checked sub-categories
$(document).ready(function(){
	$(".check_box_tree input[type=checkbox]")
		.change(function (e) {
			box = $(this);
			ancestor_tree_items = box.parents(".controls").closest("span")
			if(ancestor_tree_items) { 
				if (box.is(":checked")) {
					parent_icons = ancestor_tree_items.find("i:first");
					parent_icons.attr("class","icon-minus");
				} else {
					last_ancestor = ancestor_tree_items.last();
					child_items_of_last_ancestor = last_ancestor.children("ul").children("div.controls").children("li").children("span"); 
					if (child_items_of_last_ancestor.children("input[type=checkbox]:checked").size() < 1) {
						last_ancestor.find("i:first").attr("class","icon-ok");
					}
				}
			}
		}).trigger('change')
});
