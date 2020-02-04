###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

accordion = ->
  $accordions = $('.Accordion')

  # Set up accordions that are fully closed initially
  $accordions.not('.Accordion--activated').accordion
    header: 'a.Accordion-header'
    heightStyle: 'content'
    collapsible: true
    animate: 400
    active: false

  # Set up accordions with first panel open initially
  $accordions.filter('.Accordion--activated').accordion
    header: 'a.Accordion-header'
    heightStyle: 'content'
    collapsible: true
    animate: 400
    active: 0


  $accordions
    .removeClass('ui-accordion ui-widget ui-helper-reset')
  $('.Accordion-header', $accordions)
    .removeClass('ui-accordion-header ui-helper-reset ui-state-default ' +
      'ui-accordion-header-active ui-corner-top ui-accordion-icons ' +
      'ui-state-focus')
  $('.Accordion-header span', $accordions)
    .removeClass('ui-accordion-header-icon ui-icon ui-icon-triangle-1-s')


  # event handlers

  # for scrolling
  $accordions
    .filter('.Accordion--scrollToActive')
    .on('accordionactivate', (event, ui) ->
      unless ui.newHeader.length is 0
        $('html, body').animate
          scrollTop: ui.newHeader.offset().top
        , 400
    )


  # Open accordion if anchor link is clicked
  # TODO: Refactor both handlers, very similar
  $('.accordion-anchor').click ->
    $target_el = $($(@).attr('href'))
    target_index = $target_el
      .siblings('.Accordion-item')
      .addBack()
      .index($target_el)
    $target_el
      .closest('.Accordion')
      .accordion('option', 'active', target_index)


  # Open specific accordion on load, either via fragment identifier
  # or if one accordion has a class of .Accordion-item--active
  $target_el = $('.Accordion-item--active')
  if $target_el.length is 0 and window.location.hash
    $target_el = $('.Accordion-item' + window.location.hash)

  if $target_el.length > 0
    target_index = $target_el
      .siblings('.Accordion-item')
      .addBack()
      .index($target_el)
    $target_el
      .closest('.Accordion')
      .accordion('option', 'active', target_index)


$(document).on('page:done ready', accordion)
