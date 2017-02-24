###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

####### Still needs refactoring! #######

$(document).ready ->
  iban = $('#iban').value
  bic = $('#bic').value

  $('#iban').focusout ->
    iban = this.value
    removeWarning '#user_iban_input'
    $.getJSON '/bank_details/check_iban.json', "iban="+iban, (result) ->
      console.log result
      unless result
        addWarning '#user_iban_input', 'Bitte IBAN überprüfen.'

  $('#bic').focusout ->
    bic = this.value
    removeWarning '#user_bic_input'
    $.getJSON '/bank_details/check_bic.json', "bic="+bic, (result) ->
      console.log result
      unless result
        addWarning '#user_bic_input', 'Bitte BIC überprüfen.'

addWarning = (element, message)->
  $("<p>").appendTo(element).addClass('inline-errors').html(message)
  $('#user_bankaccount_warning').checked = true
removeWarning = (element) ->
  $(element+' .inline-errors').remove()
  $('#user_bankaccount_warning').checked = false
