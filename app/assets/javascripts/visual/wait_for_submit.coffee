###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

visualSubmit = ->
  $(".js-visual-submit").submit ->
    btn = $("input[type=submit][data-clicked=true]")
    btn.attr "disabled", "disabled"
    btn.attr "class", btn.attr("class") + " Button--disabled"
    btn.attr "value", I18n.t('javascript.common.actions.submitting')
    true

  $("form input[type=submit]").click ->
    $("input[type=submit]", $(@).parents("form")).removeAttr "data-clicked"
    $(@).attr "data-clicked", "true"

$(document).ready visualSubmit
$(document).ajaxStop visualSubmit
