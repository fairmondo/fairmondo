###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
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
        $('body').prepend htmlcontents

    $('.Notice--confirmation .confirmation_message').html(html)
    $('.Notice--confirmation .Button.confirm').on 'click', ->
      $.rails.confirmed(link)
    $('.Notice--confirmation .Button.cancel').on 'click', ->
      $('.Notice--confirmation').remove()
  ), "html"

