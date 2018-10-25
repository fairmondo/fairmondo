###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

setNewsClickHandler = ->
  $('.l-news-header').on 'click', '.l-news-header-close', onClickCloseButton

onClickCloseButton = (event) ->
  removeNotice(event)
  if($(event.target).hasClass('downtime-warning'))
    setCookie('downtime-warning-disabled',10)
  else
    setCookie('news-header-disabled',90)

removeNotice = (event) ->
  $(event.target).parents('.l-news-header').remove()

setCookie = (label,days_to_expire) ->
  expiration_date = new Date(Date.now() + (days_to_expire * 24 * 60 * 60 * 1000))
  document.cookie = "#{label}=true; path=/; expires=#{expiration_date.toUTCString()}"

$(document).ready setNewsClickHandler