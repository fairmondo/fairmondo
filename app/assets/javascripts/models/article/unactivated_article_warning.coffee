
window.onbeforeunload = ->
  'Achtung, Du hast Deinen Artikel noch nicht eingestellt. Um das zu tun, klicke auf "Angebot gebührenpflichtig einstellen".'

unobstructedNavigation = (e) ->
  window.onbeforeunload = null

unobstructedNavigationBinds = ->
  $('.l-main input.Button').on 'click', unobstructedNavigation
  $('.l-main a.Button').on 'click', unobstructedNavigation


$(document).ready unobstructedNavigationBinds
$(document).ajaxStop unobstructedNavigationBinds