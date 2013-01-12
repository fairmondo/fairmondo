
// refs #152

function feeAccordingToCommendation() {
	ecologic = $("input#auction_ecologic").is(":checked");
	fair = $("input#auction_fair").is(":checked");
	if (ecologic || fair) {
		return 0.025
	} else {
		return 0.05
	}
}

$(document).ready(function(){
	var price_input = $("input#auction_price");
	var corruption_input = $("input#auction_corruption_percent_result");
	var friendly_percent_input = $("input#auction_friendly_percent_result");
	var fees_input = $("input#auction_fees");
	var fees_and_donations_input = $("input#auction_fees_and_donations");
	
	var calculated_inputs = [corruption_input, friendly_percent_input, fees_input];
	
	var all_inputs = calculated_inputs.slice(0);
	all_inputs.push(price_input);
	
	for (var i=0;i<all_inputs.length;i++) {
		all_inputs[i]
			.change(function () {
				if(price_input.val()) {
				  price = parseFloat(price_input.val().replace(",","."));
				  if(price) {
				  	sum = 0.0
				  	for (var j=0;j<calculated_inputs.length;j++) {
				  		if(calculated_inputs[j].val()) {
				  			calculated_value = parseFloat(calculated_inputs[j].val().replace(",",".").replace(" Euro",""));
				  			if(calculated_value) {
				  				sum += calculated_value 
				  			} 
				  		}
				  	}
				  	fees_and_donations_input.val(sum.toFixed(2).toString().replace(".",",") + " Euro")
				  }
				}
			});
	}
	
	price_input
		.change(function () {
			if(price_input.val()) {
			  price = parseFloat(price_input.val().replace(",","."));
			  if(price) {
			  	corruption_caluclated = (price*(0.01))
			  	corruption_input.val(corruption_caluclated.toFixed(2).toString().replace(".",",") + " Euro")
			  	corruption_input.trigger('change')
			  }
			}
		});
		
	$("input#auction_price,input#auction_ecologic,input#auction_fair")
		.change(function () {
			if(price_input.val()) {
			  price = parseFloat(price_input.val().replace(",","."));
			  if(price) {
			  	fees_caluclated = (price*(feeAccordingToCommendation()))
			  	fees_input.val(fees_caluclated.toFixed(2).toString().replace(".",",") + " Euro")
			  	fees_input.trigger('change')
			  }
			}
		});
	
	price_input.trigger('change');
});
