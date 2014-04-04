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

//= require jquery
//= require jquery_ujs
//= require vendor/jquery.colorbox

$(document).ready(function(){
  $(".NewsHeader-close").click(function() {
    $(".NewsHeader").slideUp();
    var date = new Date(Date.now() + (24 * 60 * 60 * 1000)); // set date to one day from now
    document.cookie = "news-header-disabled=true; path=/; expires=" + date.toGMTString();
  } );
});