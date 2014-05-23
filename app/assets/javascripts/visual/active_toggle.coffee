$ ->
  ## GENERAL
  $('body').on('click', '.JS-active-toggle--trigger', (e) ->
    if (max = $(@).attr('data-maxsize')) and $(window).width() > max
      return true

    container = $(@).closest '.JS-active-toggle--container' # for scoping
    container.toggleClass 'is-active' if container.hasClass('JS-active-toggle--target')
    container.find(".JS-active-toggle--target").toggleClass('is-active')

    #negative scope
    exclusiveContainer = $(@).closest '.JS-active-toggle--exclusive-container'
    exclusiveContainer.find(".JS-active-toggle--container").each (i, iteratedContainer) ->
      unless iteratedContainer is container[0]
        $(iteratedContainer).find(".JS-active-toggle--target").removeClass 'is-active'

    if $(@).attr('data-clickable') == undefined
      e.preventDefault()
      false
    else
      true
  )

  $('body').on('click', (e) ->
    unless $('.JS-active-toggle--container .JS-active-toggle--target.is-active').length == 0
      container = $(e.target).parents('.JS-active-toggle--container')
      active_targets = $('.JS-active-toggle--container .JS-active-toggle--target.is-active')
      if container.length == 0
        active_targets.toggleClass 'is-active'
        return
      active_targets.each (index, item) ->
        if container[0] != $(item).parents('.JS-active-toggle--container')[0]
          $(item).toggleClass 'is-active'
  )
