###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
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
          HandlebarsTemplates['autocomplete/suggest']
            title: title
        else if suggestion['data']['type'] == 'result'
          HandlebarsTemplates['autocomplete/result']
            data: suggestion['data']
            title: title
        else if suggestion['data']['type'] == 'more'
          HandlebarsTemplates['autocomplete/more']
            suggestion: suggestion

$(document).ready autocomplete_hook
$(document).on 'autocompletereload', autocomplete_hook
