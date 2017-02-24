###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

# refs #200
# Todo Localize

convertInputFormatToFloat = (val) ->
	parseFloat(val.replace(/\./g,"").replace(",",".")) # Remove any "." and convert "," to "."


convertCalculatedInputFormatToFloat = (val) ->
	convertInputFormatToFloat(val.replace(" Euro",""))


convertFloatToCalculatedInputFormat = (val) ->
	val.toFixed(2).toString().replace(".",",") + " Euro"
