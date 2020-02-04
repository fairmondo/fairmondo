###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

$(document).ready ->

  # Hide edit section per default (not doing this per CSS because our
  # current test suite doesn't support JavaScript
  $('.library-edit-settings').hide()

  # Show edit section when button is clicked
  $('.js-library-edit-trigger').click (e) ->
    $(e.target).siblings('.library-edit-settings').slideToggle('fast')
    false

  # Scroll to and focus on new library form in library index view
  $('#library-form-link a').click ->
    $('html, body').animate(
      { scrollTop: $('#library-form').offset().top }, ->
        $('#new_library_name').focus()
    )
