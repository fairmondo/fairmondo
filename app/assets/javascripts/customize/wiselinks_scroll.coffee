# extend Wiselinks to add the scroll positions to the history state object
originalLoad = window._Wiselinks.Page.prototype.load
window._Wiselinks.Page.prototype.load = (url, target, render = 'template') ->
  stateData = History.getState().data || {}
  stateData.scrollX = window.scrollX
  stateData.scrollY = window.scrollY
  History.replaceState(stateData, document.title, document.location.href);
  originalLoad.apply(this, arguments)

$(document).ready ->
  setScrollTop = ->
    if ! ($(this).data('scroll') == false)
      Wiselinks.scrollTop = true
  $(document)
    .off('click', 'a[data-push=true]', setScrollTop)
    .on('click', 'a[data-push=true]', setScrollTop)

  scrollPage = ->
    stateData = History.getState().data
    if Wiselinks.scrollTop
      window.scroll(0,0)
      Wiselinks.scrollTop = false
    else if stateData? && stateData.scrollY?
      window.scroll(stateData.scrollX,stateData.scrollY)
  $(document)
    .off('page:always', scrollPage)
    .on('page:always', scrollPage)
