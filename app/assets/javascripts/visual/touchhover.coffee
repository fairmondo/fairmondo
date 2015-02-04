$ ->
  $('body')
    .on('touchstart', (e) ->
      $touchedElement = $(e.target).closest('.TouchHover')
      $('.TouchHover')
        .not($touchedElement)
        .removeClass('touched')
    )
    .on('touchstart', '.TouchHover', (e) ->
      $el = $(@)

      if $el.hasClass('touched')
        return true
      else
        e.preventDefault()
        $el
          .addClass('touched')
          .children('.TouchHover--hidden')
          .fitIntoViewport()
    )
    .on('mouseenter', '.TouchHover', (e) ->
      $(@)
        .children('.TouchHover--hidden')
        .fitIntoViewport()
    )
