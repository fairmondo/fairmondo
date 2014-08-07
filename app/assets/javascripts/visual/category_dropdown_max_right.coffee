$(document).ready ->
  $('.l-header-categories > ul > li').on 'mouseenter', push_left_if_necessary # register event listener


push_left_if_necessary = (event) ->
  li = if event.target.localName is 'a' #sometimes target is li, sometimes a
    $(event.target).parent()
  else
    $(event.target)
  ul = li.children().filter('.l-header-categories-children')

  document.Fairnopoly.push_left_if_necessary ul, ->
    li.on 'mouseleave', null, ul, reset_push_left # turn off the event listener, reset "left" attr

reset_push_left = (event) ->
  $(event.target).off 'mouseleave', null, reset_push_left # event.target => li
  event.data.css 'left', '' # event.data => ul


document.Fairnopoly.push_left_if_necessary = (target, resetCallback) ->
  window_width = $(window).width()

  if target?.offset()?.left + target.outerWidth() > window_width # if element would leave window
    target.css 'left', "#{window_width - (target.offset().left + target.outerWidth())}px" # give it a negative "left" css

    resetCallback?()

