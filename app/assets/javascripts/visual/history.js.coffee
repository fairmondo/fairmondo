# This script enables the browser's back and forward buttons for
# Ajax content

$ ->
  $(window).bind "popstate", ->
    $.getScript location.href

