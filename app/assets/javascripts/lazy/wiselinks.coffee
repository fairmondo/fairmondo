###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

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
            $('body').prepend(
              Template['lazy_wiselinks'].render
                text: text
            )
    )
    $(document).on(
      'page:done'
      (event, $target, status, url, data) ->
        _paq?.push ['trackPageView']
    )
