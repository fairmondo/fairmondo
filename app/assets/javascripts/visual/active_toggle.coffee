$ ->
  ## GENERAL
  $('body').on('click', '.JS-active-toggle--trigger', (e) ->
    if (max = $(@).attr('data-maxsize')) and $(window).width() > max
      return true

    container = $(@).closest '.JS-active-toggle--container' # for scoping
    container.toggleClass 'is-active' if container.hasClass('JS-active-toggle--target')
    container.find(".JS-active-toggle--target").each (i, element) ->
      $el = $(element)
      if $el.closest('.JS-active-toggle--container')[0] == container[0]
        $el.toggleClass('is-active')
        document.Fairnopoly.push_left_if_necessary $el # Attention: We assume that users don't resize browsers. push_left is not yet reset here.

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
    if $('.JS-active-toggle--container .JS-active-toggle--target.is-active').length != 0
      container = $(e.target).parents('.JS-active-toggle--container')
      active_targets = $('.JS-active-toggle--container .JS-active-toggle--target.is-active')
      active_targets.each (index, item) ->
        active_container = $(item).parents('.JS-active-toggle--container')[0]
        unless $(active_container).data("sustained")
          if container.length == 0
            $(item).toggleClass 'is-active'
          else
            if container[0] != active_container
              $(item).toggleClass 'is-active'
  )
