colorbox_links =  ->

  $('.remote-link').on 'click', (e) ->
    $.colorbox
      transition: "none"
      opacity: 0.4
      href: $(@).attr 'href'
    false


$(document).ready colorbox_links
$(document).ajaxStop colorbox_links
