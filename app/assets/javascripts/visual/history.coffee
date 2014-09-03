# This script enables the browser's back and forward buttons for
# Ajax content

$ ->
  # $(window).bind "popstate", ->
  History.Adapter.bind window, 'statechange', ->
    currentIndex = History.getCurrentIndex()
    internal = (History.getState().data._index == (currentIndex - 1))

    unless internal
      $.getScript location.href

document.Fairnopoly.historyPush = (no_internals, url, title = null) ->
  History.pushState
    _index: if no_internals then History.getCurrentIndex() else null
  ,
    title
  ,
    url
