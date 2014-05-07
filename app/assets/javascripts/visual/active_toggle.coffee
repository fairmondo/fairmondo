$ ->
  ## GENERAL
  $('body').on('click', '.JS-active-toggle--trigger', (e) ->
    if (max = $(@).attr('data-maxsize')) and $(window).width() > max
      return true

    container = $(@).closest '.JS-active-toggle--container' # for scoping
    container.toggleClass 'is-active' if container.hasClass('JS-active-toggle--target')
    container.find(".JS-active-toggle--target").toggleClass('is-active')

    #negative scope
    exclusiveContainer = $(@).closest '.JS-active-toggle--excusive-container'
    exclusiveContainer.find(".JS-active-toggle--container").each (i, iteratedContainer) ->
      unless iteratedContainer is container[0]
        $(iteratedContainer).find(".JS-active-toggle--target").removeClass 'is-active'

    if $(@).attr('data-clickable') == undefined
      e.preventDefault()
      false
    else
      true
  )
