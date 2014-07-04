$ ->
  $('.Notice').on 'click', '.Notice-close', ->
    $(@).parent().slideUp()
