$ ->
  $(window).on 'scroll', (event) ->
    console.log window.scrollY
    $('.Notice--info').css 'top', window.scrollY
