$ ->
  $(window).on 'scroll', (event) ->
    $('.Notice').css 'top', window.scrollY
