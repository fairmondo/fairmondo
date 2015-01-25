$ ->
  $(document).on
    'ajaxStart': ->
      $('.l-ajax-spinner').fadeIn 200
    'ajaxStop': ->
      $('.l-ajax-spinner').fadeOut 200
