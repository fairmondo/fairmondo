###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

obstructedNavigation = (e) ->
  if confirm 'Achtung! Du hast Deinen Artikel noch nicht eingestellt.
                  \n\nMöchtest du die Seite wirklich verlassen?'
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
