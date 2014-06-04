$(document).ready ->

  $(document).bind 'touchstart', (e) ->
    currentlyClickedElement = $(e.target).closest('li.JS-touch-hover')[0]
    $('.touch-hover').not(currentlyClickedElement).removeClass('touch-hover')

  $('.JS-touch-hover').bind 'touchstart', (e) ->
    if $(@).hasClass('touch-hover')
      return true
    else
      e.preventDefault()
      $(@).addClass('touch-hover')

