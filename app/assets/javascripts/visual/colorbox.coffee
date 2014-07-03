colorbox_init = ->
  $(".colorbox").colorbox
    rel: 'gallery',
    transition: "none",
    width: "75%",
    opacity: 0.4,
    height: "75%"
    current: "{current}/{total}"
$(document).ready colorbox_init
$(document).ajaxStop colorbox_init
