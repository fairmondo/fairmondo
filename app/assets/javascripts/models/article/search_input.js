/*
 *
 * == License:
 * Fairnopoly - Fairnopoly is an open-source online marketplace.
 * Copyright (C) 2013 Fairnopoly eG
 *
 * This file is part of Fairnopoly.
 *
 * Fairnopoly is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Fairnopoly is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
 */

$(function() {
    function sources(request, response){
	  	var params = {keywords: request.term};
	  	return $.get(jQuery("#search_input").attr('data-autocomplete'), params, function(data){ response(data); }, "json");
	}
  if ($( "#search_input" ).length != 0) {
  	$( "#search_input" ).autocomplete({ source: sources }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
        return $( "<li class=\"ui-menu-item\">" )
          .append( "<a class=\"ui-corner-all\">" +  item.label + "</a>")
          .appendTo( ul );
      };
  }

 });