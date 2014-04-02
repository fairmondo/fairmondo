document.Fairnopoly.toggleActive = (e) ->
  if (max = $(@).attr('data-maxsize')) and $(window).width() > max
    return true

  container = $(@).closest '.js-active-toggle--container' # for scoping
  container.find(".js-active-toggle--target").toggleClass('is-active')
  if $(@).attr('data-clickable') == undefined
    e.preventDefault()
    false
  else
    true


$ ->

  ## GENERAL
  $(".js-active-toggle--trigger").click document.Fairnopoly.toggleActive


