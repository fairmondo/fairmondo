$(document).ready ->

  $('.remote-link').on 'click', (e) ->
    $.colorbox
      transition: "none"
      opacity: 0.4
      href: $(@).attr 'href'
    false
