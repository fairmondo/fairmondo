###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

change_quantity = ->
    $('.change_quantity.line_item input#line_item_requested_quantity').on 'input' , (event) ->
      $target = $(event.target)
      $.doTimeout 'line_item_requested_quantity', 500, ->
        $target.attr("readonly",true)
        $target.parents('form').submit()

$(document).ready change_quantity
$(document).ajaxStop change_quantity
