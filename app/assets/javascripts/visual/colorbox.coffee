colorbox_init = ->
  $(".colorbox").colorbox
    rel: 'gallery',
    transition: "none",
    maxWidth: "80%",
    opacity: 0.4,
    maxHeight: "80%"
    current: "{current}/{total}"
$(document).ready colorbox_init
$(document).ajaxStop colorbox_init

