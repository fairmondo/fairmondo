$ ->
  if $("#Teaser-news-placeholder").length isnt 0
    $.get "/toolbox/rss", (data) ->
      if data
        $("#Teaser-news-placeholder").html data
        $("#Teaser-news-placeholder").removeClass "Teaser-hide"