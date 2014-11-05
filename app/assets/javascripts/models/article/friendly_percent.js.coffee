###

 == License:
 Fairmondo - Fairmondo is an open-source online marketplace.
 Copyright (C) 2013 Fairmondo eG

 This file is part of Fairmondo.

 Fairmondo is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as
 published by the Free Software Foundation, either version 3 of the
 License, or (at your option) any later version.

 Fairmondo is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
###

$(document).ready ->

  $('.js-friendly-percent-organisation-label').hide()

  $(".js-friendly-percent-organisation-select").on "change", (event) ->
    valueSelected = @value
    textSelected = $('option:selected', @).html()
    $(".js-friendly-percent-organisation-link").html(
      Template['models_article_friendly_percent'].render
        text: textSelected
        value: valueSelected
    )

    if textSelected and textSelected.length isnt 0
      $('.js-friendly-percent-organisation-label').show()
    else
      $('.js-friendly-percent-organisation-label').hide()
