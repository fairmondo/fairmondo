$ ->
  if $("#js-teaser-news-placeholder").length isnt 0
    $.get "/toolbox/rss", (data) ->
      if data
        $("#js-teaser-news-placeholder").html data
        $("#js-teaser-news-placeholder").removeClass "teaser--hide"
