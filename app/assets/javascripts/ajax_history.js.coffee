$(document).ready ->
  if History.pushState
    History.pushState( {}, document.title, window.location.href )

    $('.l-main').on 'click', 'a', (e) ->
      console.log e
      History.pushState( {}, document.title, e.target.href)
      true
