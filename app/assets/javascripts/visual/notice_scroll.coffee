$ ->
  $(window).on 'scroll', (event) ->
    $('.Notice--info').css 'top', window.scrollY
