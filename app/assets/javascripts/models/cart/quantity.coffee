change_quantity = ->
    $('.change_quantity.line_item input#line_item_requested_quantity').on 'input' , (event) ->
      $target = $(event.target)
      $.doTimeout 'line_item_requested_quantity', 500, ->
        $target.attr("readonly",true)
        $target.parents('form').submit()

$(document).ready change_quantity
$(document).ajaxStop change_quantity

