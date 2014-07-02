$(document).ready ->
  $(".Image-titleinput").on "ifChecked", (event) ->
    $(".Image-titleinput").not(event.target).iCheck 'uncheck'
