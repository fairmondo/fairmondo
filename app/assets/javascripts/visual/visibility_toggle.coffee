document.Fairnopoly.toggleVisibility = (e) ->
  if (max = $(@).attr('data-maxsize')) and $(window).width() > max
    return true

  container = $(@).closest '.js-visual-toggle--container' # for scoping
  container.find(".js-visual-toggle--target").toggleClass('is-active')
  if $(@).attr('data-clickable') == undefined
    e.preventDefault()
    false
  else
    true


$ ->

  ## GENERAL
  $(".js-visual-toggle--trigger").click document.Fairnopoly.toggleVisibility


