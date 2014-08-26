###

== License:
Fairnopoly - Fairnopoly is an open-source online marketplace.
Copyright (C) 2013 Fairnopoly eG

This file is part of Fairnopoly.

Fairnopoly is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

Fairnopoly is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
###

# This function copies the first two comments to the comment preview for a given commentable (library)
#
document.Fairnopoly.copyCommentsToPreview = (commentable_selector) ->
  commentable = $(commentable_selector)
  first_two_comments = $(commentable_selector + ".Comments-section .Comment-single:lt(2)").clone()
  preview_element = $(commentable_selector + '.Library-comments')
  preview_element.html(first_two_comments)

$(document).ready ->
  $('.js-library-settings').hide()
  $('.js-library-show-settings').click (e) =>
    $(e.target).parent().parent().find('.js-library-settings').show()
    $(e.target).hide()



