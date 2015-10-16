###
   Copyright (c) 2012-2015, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

#= require jquery
#= require jquery_ujs
#= require vendor/jquery.colorbox

$(document).ready ->
  $(".l-news-header-close").click ->
    $(".l-news-header").slideUp(0)
    date = new Date(Date.now() + (24 * 60 * 60 * 1000)) # set date to one day from now
    document.cookie = "news-header-disabled=true; path=/; expires=" + date.toGMTString()
