accordion = ->
  target = 0
  if window.location.hash
    target = $(window.location.hash).siblings().andSelf().index($(window.location.hash))
  else
    target = $('.Accordion-item--active').index() if $('.Accordion-item--active').length > 0

  $(".accordion-anchor").click ->
    link = $(event.target).attr('href')
    target = $(link).index('.Accordion-item')
    $(".Accordion--activated").accordion
      animate: false
      active: target

  $(".Accordion").accordion
    header: "a.Accordion-header"
    heightStyle: "content"
    collapsible: true
    animate: 400
    active: false

  $(".Accordion--activated").accordion
    header: "a.Accordion-header"
    heightStyle: "content"
    collapsible: true
    animate: 400
    active: target

  $(".Accordion--scrollToActive").on "accordionactivate", (event,ui) ->
    if ui.newHeader.length isnt 0 && target
      $('html, body').animate
        scrollTop: ui.newHeader.offset().top
      , 100


  $(".Accordion").removeClass("ui-accordion ui-widget ui-helper-reset")
  $(".Accordion-header").removeClass("ui-accordion-header ui-helper-reset ui-state-default ui-accordion-header-active ui-corner-top ui-accordion-icons ui-state-focus")
  $(".Accordion-header span").removeClass("ui-accordion-header-icon ui-icon ui-icon-triangle-1-s")


$(document).on(
  'page:done'
  (event, $target, status, url, data) ->
    accordion()
)
$(document).ready accordion
