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


// refs #114
// To fix this, the element has to be on the page when it is loaded and not in a
// data-content attribute.
// But there is no way to make bootstrap actually move elements, thus
// we have to do it our own.

var parent = null;
var child = null;
var popover_just_added = true;

$(document).ready(function(){
	// popover
    $("#login-popover")
      .popover({
      	html: true,
        content: function(e) {
        	parent = document.getElementById('user-login-form');
        	child =  document.getElementById('new_user');
        	popover_just_added = true
        	parent.removeChild(child);
        	return child }
      })
      .click(function(e) {
      	if(! popover_just_added) {
      	  parent.appendChild(child);
      	}
    	popover_just_added = false;
        e.preventDefault()
      })

});