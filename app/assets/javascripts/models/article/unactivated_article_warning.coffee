obstructedNavigation = (e) ->
  if confirm 'Achtung, Du hast Deinen Artikel noch nicht eingestellt.
                  Um das zu tun, klicke auf "Angebot gebührenpflichtig
                  einstellen".
                  \n\nMöchtest du wirklich die Seite verlassen?'
    $('a:not(.Button):not([target="_blank"])').unbind 'click.obstructNavigation'
  else
    e.preventDefault
    return false

obstructedNavigationBinds = ->
  unobstructedSelectors = [
    '[target="_blank"]', '.Accordion-header', 'Notice-close',
    '.l-news-header-close'
  ]
  $("a:not(.Button):not(#{unobstructedSelectors.join(', ')})").bind(
    'click.obstructNavigation',
    obstructedNavigation
  )

$(document).ready obstructedNavigationBinds
