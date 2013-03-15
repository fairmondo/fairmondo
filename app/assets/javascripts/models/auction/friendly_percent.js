
// refs #152

$(document).ready(function(){
	var price_input = $("input#auction_price")
	var friendly_percent_input = $("input#auction_friendly_percent")
	var friendly_percent_calculated_inputs = $("input#auction_friendly_percent_calculated,input#auction_friendly_percent_result")
	
	$("input#auction_price,input#auction_friendly_percent")
		.change(function () {
			friendly_percent_calculated = 0.0
			if(price_input.val() && friendly_percent_input.val()) {
			  price = convertInputFormatToFloat(price_input.val());
			  percent = convertInputFormatToFloat(friendly_percent_input.val());
			  if (price && percent) { 
			  	friendly_percent_calculated = (price*(percent/100))
			  }
			}
			friendly_percent_calculated_inputs.val(convertFloatToCalculatedInputFormat(friendly_percent_calculated));
			friendly_percent_calculated_inputs.trigger('change')
		}).trigger('change')
});
