###

 == License:
 Fairmondo - Fairmondo is an open-source online marketplace.
 Copyright (C) 2013 Fairmondo eG

 This file is part of Fairmondo.

 Fairmondo is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as
 published by the Free Software Foundation, either version 3 of the
 License, or (at your option) any later version.

 Fairmondo is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
###

autocomplete_hook = ->
  if $( "#search_input" ).length isnt 0
    $( "#search_input" ).autocomplete
      serviceUrl: $("#search_input").data('autocomplete-remote-url')
      paramName: 'q'
      preventBadQueries: false
      triggerSelectOnValidInput: false
      appendTo: '.l-header-search-query'

      formatResult: (suggestion, currentValue) ->
        title = $.Autocomplete.formatResult suggestion, currentValue
        if suggestion['data']['type'] == 'suggest'
          Template['models_article_search_input/suggest'].render
            title: title
        else if suggestion['data']['type'] == 'result'
          Template['models_article_search_input/result'].render
            data: suggestion['data']
            title: title
        else if suggestion['data']['type'] == 'more'
          Template['models_article_search_input/more'].render
            suggestion: suggestion

$(document).ready autocomplete_hook
$(document).on 'autocompletereload', autocomplete_hook
