###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

#= require jquery
#= require jquery_ujs
#= require vendor/jquery.colorbox

$(document).ready setNewsClickHandler

setNewsClickHandler = ->
  $('.l-news-header').on 'click', '.l-news-header-close', onClickCloseButton

onClickCloseButton = (event) ->
  removeNewsHeader()
  setCookie()

removeNewsHeader = ->
  $('.l-news-header')
    .slideUp(0)
    .remove()

setCookie = ->
  days_to_expire = 1
  expiration_date = new Date(Date.now() + (days_to_expire * 24 * 60 * 60 * 1000))
  document.cookie = "news-header-disabled=true; path=/; expires=#{expiration_date.toUTCString()}"
