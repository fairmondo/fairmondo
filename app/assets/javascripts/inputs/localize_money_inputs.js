// refs #200
// Todo Localize

function convertInputFormatToFloat(val) {
	return parseFloat(val.replace(/\./g,"").replace(",",".")); // Remove any "." and convert "," to "."
}

function convertCalculatedInputFormatToFloat(val) {
	return convertInputFormatToFloat(val.replace(" Euro",""))
}

function convertFloatToCalculatedInputFormat(val) {
	return val.toFixed(2).toString().replace(".",",") + " Euro"
}