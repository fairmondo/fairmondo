
// refs #152

$(document).ready(function(){
	var price_input = $("input#auction_price")
	var friendly_percent_input = $("input#auction_friendly_percent")
	var friendly_percent_caluclated_inputs = $("input#auction_friendly_percent_calculated,input#auction_friendly_percent_result")
	
	$("input#auction_price,input#auction_friendly_percent")
		.change(function () {
			if(price_input.val() && friendly_percent_input.val()) {
			  price = parseFloat(price_input.val().replace(",","."));
			  percent = parseFloat(friendly_percent_input.val().replace(",","."));
			  if (price && percent) { 
			  	friendly_percent_caluclated = (price*(percent/100))
			    friendly_percent_caluclated_inputs.val(friendly_percent_caluclated.toFixed(2).toString().replace(".",",") + " Euro");
			  }
			  else {
			    friendly_percent_caluclated_inputs.val("0,00 Euro");
			  }
			  friendly_percent_caluclated_inputs.trigger('change')
			}
		}).trigger('change')
});
