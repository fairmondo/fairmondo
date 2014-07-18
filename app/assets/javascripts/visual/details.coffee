openGallery = () ->
  root = $('head,body')
  $(window.location.hash + " > summary").trigger("click")

$ ->
  $('details').details()

$(window).load ->
    if window.location.hash.length > 0
      openGallery()

