$ ->
  $('body')
    .on('touchstart', (e) ->
      $touchedElement = $(e.target).closest('.TouchHover')
      $('.TouchHover')
        .not($touchedElement)
        .removeClass('touchhovered')
    )
    .on(
      touchstart: (e) ->
        $el = $(@)

        if $el.hasClass('touchhovered')
          return true
        else
          e.preventDefault()
          $el
            .addClass('touchhovered')
            .children('.TouchHover--hidden')
            .fitIntoViewport()

      mouseenter: (e) ->
        $(@)
          .addClass('touchhovered')
          .children('.TouchHover--hidden')
          .fitIntoViewport()

      mouseleave: (e) ->
        # Don't remove class if related target is Browser UI. This is vital if
        # the dropdown includes input elements, because of autocorrection
        # kicking in.
        unless e.relatedTarget is null
          $(@).removeClass('touchhovered')

    , '.TouchHover')
