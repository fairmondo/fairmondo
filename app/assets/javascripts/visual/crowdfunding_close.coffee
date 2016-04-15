###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

setCrowdfundingClickHandler = ->
  $('.l-crowdfunding-full-closebutton > a').click onClickCloseButton

onClickCloseButton = (event) ->
  event.preventDefault()
  removeCrowdfunding()
  setCookie()

removeCrowdfunding = ->
  $('.l-crowdfunding-full')
    .remove()

setCookie = ->
  days_to_expire = 1
  expiration_date = new Date(Date.now() + (days_to_expire * 24 * 60 * 60 * 1000))
  document.cookie = "crowdfunding-do-not-show=true; path=/; expires=#{expiration_date.toUTCString()}"

$(document).ready setCrowdfundingClickHandler
