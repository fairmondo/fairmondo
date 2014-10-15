$ ->
  $(".Library").click (e) ->
    if $(e.target).is('a, i')
      e.stopImmediatePropagation
    else
      window.location=$(this).find("a.library-link").attr("href")
