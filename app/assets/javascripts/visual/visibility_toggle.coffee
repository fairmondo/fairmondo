document.Fairnopoly.toggleVisibility = (e) ->
  if (max = $(@).attr('data-maxsize')) and $(window).width() > max
    return true

  container = $(@).closest '.js-visual-toggle--container' # for scoping
  container.find(".js-visual-toggle--target").toggleClass('is-active')

  e.preventDefault()
  false


$ ->

  ## GENERAL
  $(".js-visual-toggle--trigger").click document.Fairnopoly.toggleVisibility


  ## FILTER
  $('#search_input').focus ->
    $('.Filter').addClass('is-active')

  # disable defaultly displayed advanced search box for mobile width
  if ($(window).width() < 680)
    $('.Hero-search .Filter').removeClass('is-active')

