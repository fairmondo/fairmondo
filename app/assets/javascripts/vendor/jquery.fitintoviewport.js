/*   Copyright (c) 2012-2015, Fairmondo eG.  This file is
 *   licensed under the GNU Affero General Public License version 3 or later.
 *   See the COPYRIGHT file for details.
 */


/*
 * jQuery plugin fitIntoViewport
 * ---------------------------
 * Repositions element(s) horizontally if some parts of them are not in the
 * viewport.
 * If element
 *  - is bigger than window -> center
 *  - reaches over left edge -> push right
 *  - reaches over right edge -> push left
 *
 */

(function( $ ) {
  $.fn.fitIntoViewport = function() {
    var window_width = $(window).width();

    return this.each(function() {
      var $this = $(this),
        left_offset, outer_width, offset_parent,
        absolute_x, relative_x;

      // clear target css 'left' and 'right' before calculating
      $this.css({
        left  : '',
        right : ''
      });

      left_offset = $this.offset().left;
      outer_width = $this.outerWidth();

      // recalculate x position
      if (outer_width > window_width) {
        absolute_x = Math.floor((window_width - outer_width) / 2);
      }
      else if (left_offset < 0) {
        absolute_x = 0;
      }
      else if (left_offset + outer_width > window_width) {
        absolute_x = window_width - outer_width;
      }
      else {
        return false;
      }

      // calculate x relative to offset parent
      offset_parent = left_offset - $this.position().left;
      relative_x = absolute_x - offset_parent;

      $this.css({
        left  : relative_x,
        right : 'auto'
      });
    });
  };
}( jQuery ));
