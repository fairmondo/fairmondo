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
*/

$(document).ready(function(){
  $("i.icon-helper").tooltip
  (
  {
    tooltipClass: "bottom", // class for the arrow/pointer
    position:
    {
      my: "center top",
      at: "center bottom+20"
    },
    open: function( e, ui ) {
    	$(e.target).data("opened",true);
    },
    close: function( e, ui ) {
    	$(e.target).data("opened",false);
    },
    content: function()
    {
      return $(this).attr('title').split('\n').join('<br/>');  // this allows line breaks
    }
  }
  ).off('mouseover');



  $("i.icon-helper").on( "mouseleave", function( e ) {
    e.stopImmediatePropagation();
  });
  $("i.icon-helper").on('click',function(e) {
    e.stopPropagation();

    alreadyopen = $(e.target).data("opened");
    $("i.icon-helper").tooltip('close'); //Close all open tooltips
    if(!alreadyopen) { //Only reopen tooltip if it was in closed state before
    	$(e.target).tooltip('open');
    }
  });

  $('html').delegate('.ui-tooltip-content' ,'click',function(e){
    e.stopPropagation();
  });
  $('html').click(function(e) {
    $("i.icon-helper").tooltip('close');
  });

});

