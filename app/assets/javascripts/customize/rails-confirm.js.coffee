###

== License:
Fairnopoly - Fairnopoly is an open-source online marketplace.
Copyright (C) 2013 Fairnopoly eG

This file is part of Fairnopoly.

Fairnopoly is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

Fairnopoly is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
###
$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look bellow for implementations
  false # always stops the action since code runs asynchronously

$.rails.confirmed = (link) ->
  link.removeAttr('data-confirm')
  link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
  html = link.attr('data-confirm')
  window.scrollTo(0, 0);
  $.get "/toolbox/confirm.js", ((data) ->
    htmlcontents = $(data)
    if $('.Notice--confirmation').length is 0
      if $('.Notice').length
        $('.Notice').last().after htmlcontents
      else
        $('.l-wrapper').prepend htmlcontents

    $('.Notice--confirmation .confirmation_message').html(html)
    $('.Notice--confirmation .Button.confirm').on 'click', ->
      $.rails.confirmed(link)
    $('.Notice--confirmation .Button.cancel').on 'click', ->
      $('.Notice--confirmation').remove()
  ), "html"

