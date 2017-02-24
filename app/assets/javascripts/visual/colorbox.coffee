###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

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
