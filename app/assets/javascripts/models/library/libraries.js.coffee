 $(document).ready ->
   $('.library_settings').hide()
   $('.library_settings_show').click (e) =>
      $(e.target).parent().parent().find('.library_settings').show()
      $(e.target).hide()



