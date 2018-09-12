###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

setNewsClickHandler = ->
  $('.l-news-header').on 'click', '.l-news-header-close', onClickCloseButton

onClickCloseButton = (event) ->
  removeNewsHeader()
  setCookie()

removeNewsHeader = ->
  $('.l-news-header')
    .remove()

setCookie = ->
  days_to_expire = 90
  expiration_date = new Date(Date.now() + (days_to_expire * 24 * 60 * 60 * 1000))
  document.cookie = "news-header-disabled=true; path=/; expires=#{expiration_date.toUTCString()}"

$(document).ready setNewsClickHandler
