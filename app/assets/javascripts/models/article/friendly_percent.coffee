###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
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
