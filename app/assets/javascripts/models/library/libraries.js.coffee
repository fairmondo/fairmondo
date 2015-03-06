###

== License:
Fairmondo - Fairmondo is an open-source online marketplace.
Copyright (C) 2013 Fairmondo eG

This file is part of Fairmondo.

Fairmondo is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

Fairmondo is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
###

$(document).always ->

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
