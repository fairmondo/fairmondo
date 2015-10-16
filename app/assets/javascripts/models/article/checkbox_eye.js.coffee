###
   Copyright (c) 2012-2015, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

# Click-Handler setzen fürs Auge
# Klassenstatus abfragen, Auge und Formularstatus entsprechend ändern

library_checkboxes =  ->
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


$(document).ready library_checkboxes
$(document).ajaxStop library_checkboxes
