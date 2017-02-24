###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

# extend Wiselinks to add the scroll positions to the history state object
originalCall = window._Wiselinks.Page.prototype._call
window._Wiselinks.Page.prototype._call = (state) ->
  return if Wiselinks.skipLoadingPage
  originalCall.apply(this, arguments)

originalLoad = window._Wiselinks.Page.prototype.load
window._Wiselinks.Page.prototype.load = (url, target, render = 'template') ->
  stateData = History.getState().data || {}
  stateData.scrollX = window.scrollX
  stateData.scrollY = window.scrollY
  Wiselinks.skipLoadingPage = true
  History.replaceState(stateData, document.title, document.location.href);
  Wiselinks.skipLoadingPage = false
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
