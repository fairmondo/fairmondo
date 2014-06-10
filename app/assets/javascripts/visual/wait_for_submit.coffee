$(document).ready ->
  $(".js-visual-submit").submit ->
    btn = $("input[type=submit][data-clicked=true]")
    btn.attr "disabled", "disabled"
    btn.attr "class", btn.attr("class") + " Button--disabled"
    btn.attr "value", I18n.t('javascript.common.actions.submitting')
    true

  $("form input[type=submit]").click ->
    $("input[type=submit]", $(@).parents("form")).removeAttr "data-clicked"
    $(@).attr "data-clicked", "true"