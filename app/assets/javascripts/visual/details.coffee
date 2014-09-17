$ ->
  $('.l-main').on 'click', 'summary', onSummaryClick

setDetails = ->
  $('details').details()

onSummaryClick = (evt) ->
    [target, summary, details] = [evt.target, evt.currentTarget, evt.currentTarget.parentElement]
    id = details.id
    libraryID = id.split('library')[1]

    unless $(target).parentsUntil(summary).add($(target)).is('a, button, input')
      $(".Library:not(#library#{libraryID})").attr("open", null) # close all others
      $("html, body").animate({ scrollTop: $("#library#{libraryID}").offset().top }, 200) # scroll

$(document).ready setDetails
$(document).ajaxStop setDetails
