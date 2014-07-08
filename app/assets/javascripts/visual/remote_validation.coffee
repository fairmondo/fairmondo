$ ->
  $('.JS-remote-validation').on 'keydown change', '.JS-validate', (event) ->
    $.post '/remote_validations/line_item/requested_quantity/40?article_id=22', (response) ->
       response
