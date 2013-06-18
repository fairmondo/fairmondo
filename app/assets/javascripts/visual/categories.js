
$(document).ready(function(){
	var generated_select_option_number=0;
	$("#article_categories_and_ancestors").selectBoxIt();
	$("#article_categories_and_ancestors").addClass("article_categories_and_ancestors_selectbox");
	$("#article_categories_and_ancestors").change(function() { $("#article_categories_and_ancestors").nextAll("select").remove(); $.getScript("/categories/"+$('option:selected',$(this)).attr("value"))  });
	$('#article_categories_and_ancestors_input').css("overflow", "visible");
	$('#article_categories_and_ancestors_input').parents().css("overflow", "visible");
	$('#article_categories_and_ancestors_input').append("<a class=\"Btn\" id=\"article_categories_and_ancestors_select\" \">Auswaehlen</a>");
	$('#article_categories_and_ancestors_select').click(function() {
		selected_values = []
		selected_texts = []
		$( "select.article_categories_and_ancestors_selectbox" ).each(function( index ) {
			option = $('option:selected:first',$(this));
			value = option.attr("value");
			text = option.text();
			if (value && value != "-1" && text!="generated") {
				selected_values.push(value);
				selected_texts.push(text);
			}
		});
		if(selected_values.length > 0) {
			display = 'generated_select_option_display' + generated_select_option_number;
			$('#article_categories_and_ancestors_input').append("<input type=\"hidden\" name=\"article[categories_and_ancestors][]\" value=\""+selected_values[selected_values.length-1]+"\"></input></a><p id="+display+">"+selected_texts.join(" > ")+ "<a class=\"Btn\" data-delete=\""+generated_select_option_number+"\">Loeschen</a></p>");
			
			$('#'+display+' > a' ).click(function() {
				clicked_link =$(this);
				$.each(selected_values, function(index,value) {
					delete_element = ".generated_select_option_"+clicked_link.data("delete");
					$(delete_element).remove();
					
				});
				$('#'+display).remove();
			})
		}
		generated_select_option_number++;
	});
});