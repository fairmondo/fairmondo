###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

colorbox_links =  ->

  $('.remote-link').on 'click', (e) ->
    $.colorbox
      transition: "none"
      opacity: 0.4
      href: $(@).attr 'href'
    false


$(document).ready colorbox_links
$(document).ajaxStop colorbox_links
