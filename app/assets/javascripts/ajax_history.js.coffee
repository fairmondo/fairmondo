$(document).ready ->
  if History.pushState

    History.pushState( null, document.title, window.location.href )

    $('.l-main').on 'click', 'a', (e) ->
      History.pushState( null, document.title, e.target.href)
      true
