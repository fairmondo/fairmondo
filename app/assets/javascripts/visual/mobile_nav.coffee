###
   Copyright (c) 2012-2015, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

$ ->
  $('#l-header-mnav-toggle').click( ->
    $('.l-header-mnav-menu').slideToggle 'fast'
    $(@).toggleClass 'l-header-mnav--active'

    false
  )

  $('#l-header-mnav a').click( ->
    $('.l-header-mnav-menu').slideUp 'fast'
    $('#l-header-mnav-toggle').removeClass 'l-header-mnav--active'
  )
