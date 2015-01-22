colorbox_init = ->
  $(".colorbox").colorbox
    rel: 'gallery',
    transition: "elastic",
    maxWidth: "80%",
    opacity: 0.4,
    maxHeight: "80%"
    current: "{current}/{total}"
  $(".ungrouped_colorbox").colorbox
    transition: "elastic",
    maxWidth: "80%",
    opacity: 0.4,
    maxHeight: "80%"

$(document).ready colorbox_init
$(document).ajaxStop colorbox_init
