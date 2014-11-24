
# extend Wiselinks to add the scroll positions to the history state object
originalLoad = window._Wiselinks.Page.prototype.load
window._Wiselinks.Page.prototype.load = (url, target, render = 'template') ->
    stateData = History.getState().data || {}
    stateData.scrollX = window.scrollX
    stateData.scrollY = window.scrollY
    History.replaceState(stateData, document.title, document.location.href);
    originalLoad.apply(this, arguments)

$(document).ready ->
    window.wiselinks = new Wiselinks('.l-main', html4: false)
    $(document).off('page:fail').on(
        'page:fail'
        (event, $target, status, url, error, code) ->
          if code==404
            text = "Die aufgerufene Seite konnte nicht gefunden werden."
          else
            text = "Entschuldigung, da ist wohl etwas schiefgelaufen. Die Seite die du aufrufen wolltest funktioniert nicht richtig."
          if $('#page_error').length == 0
            $('.l-wrapper').prepend(
              Template['lazy_wiselinks'].render
                text: text
            )
    )
    $(document).on(
      'page:done'
      (event, $target, status, url, data) ->
        _paq?.push ['trackPageView']
    )
    $(document).on('click', 'a[data-push=true]'
      (event) ->
        if ! ($(this).data('scroll') == false)
          Wiselinks.scrollTop = true
    )
    $(document).off('page:always').on('page:always'
      (event, $target, status, state) ->
        stateData = History.getState().data
        if stateData? && stateData.scrollY?
          window.scroll(stateData.scrollX,stateData.scrollY)
        else if Wiselinks.scrollTop
          window.scroll(0,0)
          Wiselinks.scrollTop = false
    )
