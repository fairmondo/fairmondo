$ ->
  $('body').on 'submit', '#colorbox', (event) ->
    $.colorbox.close()
    true
