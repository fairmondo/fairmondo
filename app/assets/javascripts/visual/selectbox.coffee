
document.Fairnopoly.selectboxit = ->
  # unless /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
  $('select').selectBoxIt
    autoWidth: false
  $('body').on 'click','span.selectboxit-container', (e) ->
    $('span.selectboxit-container').parents().css("overflow", "visible")

$(document).ready document.Fairnopoly.selectboxit

$(document).ajaxStop document.Fairnopoly.selectboxit
