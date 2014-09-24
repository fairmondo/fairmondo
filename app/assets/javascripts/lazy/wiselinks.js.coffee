
$(document).ready ->
    window.wiselinks = new Wiselinks('.l-main')
    $(document).off('page:fail').on(
        'page:fail'
        (event, $target, status, url, error, code) ->
          if code==404
            text = "Die aufgerufene Seite konnte nicht gefunden werden."
          else
            text = "Entschuldigung, da ist wohl etwas schiefgelaufen. Die Seite die du aufrufen wolltest funktioniert nicht richtig."
          if $('#page_error').length == 0
            $('.l-wrapper').prepend("<div class='Notice Notice--error' id='page_error'> <div class='Notice-inner'>" + text + "</div><a class='Notice-close'><i class='fa fa-times-circle fa-lg'></i></a/></div>")
    )
    $(document).on(
      'page:done'
      (event, $target, status, url, data) ->
        _paq.push ['trackPageView']
    )