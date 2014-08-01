openGallery = () ->
  root = $('head,body')
  $(window.location.hash + " > summary").trigger("click")

$ ->
  $('details').details()
  $('summary').on('click', (evt) ->
    id = evt.delegateTarget.parentElement.id
    if !$(evt.target).parentsUntil(evt.delegateTarget).add($(evt.target)).is('a, button, input')
      $("html, body").animate({ scrollTop: $('#' + id).offset().top }, 200);
      window.location.href = "#" + id
    )

$(window).load ->
    if window.location.hash.length > 0
      openGallery()

