###

 == License:
 Fairnopoly - Fairnopoly is an open-source online marketplace.
 Copyright (C) 2013 Fairnopoly eG

 This file is part of Fairnopoly.

 Fairnopoly is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as
 published by the Free Software Foundation, either version 3 of the
 License, or (at your option) any later version.

 Fairnopoly is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
###

autocomplete_hook = ->
  if $( "#search_input" ).length isnt 0
    $( "#search_input" ).autocomplete
      serviceUrl: $("#search_input").data('autocomplete-remote-url'),
      paramName: 'q',
      preventBadQueries: false,
      triggerSelectOnValidInput: false,

      formatResult: (suggestion,currentValue) ->
        title = $.Autocomplete.formatResult(suggestion,currentValue)
        if suggestion['data']['type'] == 'suggest'
          "<span class=\"autocomplete-title\">" + title + "</span>"
        else if suggestion['data']['type'] == 'result'
          "<a href="+suggestion['data']['url']+" data-push='true'><span class=\"autocomplete-thumbnail\">"+suggestion['data']['thumb']+"</span><span class=\"autocomplete-title\">" + title + "</span></a>"
        else if suggestion['data']['type'] == 'more'
          "<a href=\"/articles/?q="+suggestion.value+"\" data-push=true><span class=\"autocomplete-title\"> Alle " + suggestion['data']['count'] + " Ergebnisse für <strong>"+ suggestion.value + "</strong></span></a>"

$(document).ready autocomplete_hook
$(document).on 'autocompletereload', autocomplete_hook
