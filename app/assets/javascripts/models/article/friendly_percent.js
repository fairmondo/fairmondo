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

$(document).ready(function(){

  $('.Friendly_percent_ngo_label').hide();

  $(".Friendly_percent_select").on("change", function(event) {
    var valueSelected = this.value;
    var textSelected = $('option:selected', this).html();
    $(".Friendly_percent_ngo_label_link").html( "<a href=\"/users/" + valueSelected + "\" target=\"_blank\">" + textSelected + "</a>" );
    if(textSelected && textSelected.length != 0){
      $('.Friendly_percent_ngo_label').show();
    }
    else {
      $('.Friendly_percent_ngo_label').hide();
    }
  })
   ;
});