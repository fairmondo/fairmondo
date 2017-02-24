###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

$ ->
  if $("#js-teaser-news-placeholder").length isnt 0
    $.get "/toolbox/rss", (data) ->
      if data
        $("#js-teaser-news-placeholder").html data
        $("#js-teaser-news-placeholder").removeClass "teaser--hide"
