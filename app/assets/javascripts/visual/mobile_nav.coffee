$ ->
  $('#l-header-mnav-toggle').click( ->
    $('.l-header-mnav-menu').slideToggle 'fast'
    $(@).toggleClass 'l-header-mnav--active'

    false
  )

  $('#l-header-mnav a').click( ->
    $('.l-header-mnav-menu').slideUp 'fast'
    $('#l-header-mnav-toggle').removeClass 'l-header-mnav--active'
  )
