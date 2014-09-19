noticeClose = ->
  $('.Notice').on 'click', '.Notice-close', ->
    $(@).parent().slideUp(0)
    $(@).parent().remove()
$(document).ready noticeClose
$(document).ajaxStop noticeClose
