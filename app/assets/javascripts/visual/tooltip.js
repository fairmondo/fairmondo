/*
 * Farinopoly - Fairnopoly is an open-source online marketplace.
 * Copyright (C) 2013 Fairnopoly eG
 *
 * This file is part of Farinopoly.
 *
 * Farinopoly is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Farinopoly is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.

$(document).ready(function(){
	$("a.input-tooltip").popover({"placement" : "left",  template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><div class="popover-content"><p></p></div></div></div>'}).click(function(e) {
        e.stopPropagation();
    });

	$(window).hashchange( function(){
	    // Alerts every time the hash changes!
	   $("a.input-tooltip").popover('hide');
  	});

	$('html').click(function(e) {
    	$("a.input-tooltip").popover('hide');
	});

});
 */

$(document).ready(function(){
	$("i.icon-helper").tooltip({
		tooltipClass: "bottom", // class for the arrow/pointer
		position: {
			my: "center top",
			at: "center bottom+20",
			collision: "none"
		}

	}).off('mouseover');
	$("i.icon-helper").on( "mouseleave", function( e ) {
		e.stopImmediatePropagation();
	});
	$("i.icon-helper").on('click',function(e) {
		e.stopPropagation();
		$("i.icon-helper").tooltip('close');
		$(e.target).tooltip('open');
	});

	$('html').delegate('.ui-tooltip-content' ,'click',function(e){
		e.stopPropagation();
	});
	$('html').click(function(e) {
		$("i.icon-helper").tooltip('close');
	});
});
