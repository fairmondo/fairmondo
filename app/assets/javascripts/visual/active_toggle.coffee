$ ->
  ## GENERAL
  $('body').on('click', '.JS-active-toggle--trigger', (e) ->
    if (max = $(@).attr('data-maxsize')) and $(window).width() > max
      return true

    container = $(@).closest '.JS-active-toggle--container' # for scoping
    container.find(".JS-active-toggle--target").toggleClass('is-active')
    if $(@).attr('data-clickable') == undefined
      e.preventDefault()
      false
    else
      true
)
