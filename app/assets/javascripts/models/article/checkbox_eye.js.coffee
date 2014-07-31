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

# Click-Handler setzen fürs Auge
# Klassenstatus abfragen, Auge und Formularstatus entsprechend ändern

$(document).ready ->
  $('#libraries_popup').on 'click', '#eye_checkbox', ->
    if not $('#eye_checkbox').hasClass('fa-eye')
      $('#eye_checkbox').addClass 'fa-eye'
      $('#eye_checkbox').removeClass 'fa-eye-slash'
      $('#eye_checkbox').attr 'title', 'Öffentliche Sammlung'
      $('#library_public').attr 'value', '1'
    else
      $('#eye_checkbox').addClass 'fa-eye-slash'
      $('#eye_checkbox').removeClass 'fa-eye'
      $('#eye_checkbox').attr 'title', 'Private Sammlung'
      $('#library_public').attr 'value', '0'
