$ ->
  $(document).ajaxStart ->
    $('.l-ajax-spinner').fadeIn 200

  $(document).ajaxStop ->
    $('.l-ajax-spinner').fadeOut 200
