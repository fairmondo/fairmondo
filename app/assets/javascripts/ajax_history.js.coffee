$(document).ready ->

    document.Fairnopoly.historyPush false, window.location.href, document.title

    $('.l-main').on 'click', 'a', (e) ->
      document.Fairnopoly.historyPush false, e.target.href, document.title
      true
