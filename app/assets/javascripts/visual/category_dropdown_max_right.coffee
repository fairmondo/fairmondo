$(document).ready ->
  $('.l-header-categories > ul > li').on 'mouseenter', push_left_if_necessary # register event listener


push_left_if_necessary = (event) ->
  li = if event.target.localName is 'a' #sometimes target is li, sometimes a
    $(event.target).parent()
  else
    $(event.target)
  ul = li.children().filter('.l-header-categories-children')
  window_width = $(window).width()

  if ul?.offset()?.left + ul.width() > window_width # if element would leave window
    ul.css 'left', "#{window_width - (ul.offset().left + ul.width())}px" # give it a negative "left" css

    li.on 'mouseleave', null, ul, reset_push_left # turn off the event listener, reset "left" attr

reset_push_left = (event) ->
  $(event.target).off 'mouseleave', null, reset_push_left # event.target => li
  event.data.css 'left', '' # event.data => ul
