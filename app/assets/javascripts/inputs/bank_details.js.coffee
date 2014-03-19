####### Still needs refactoring! #######

$(document).ready ->
  account = $('#bank_account_number').value
  bank_code = $('#bank_code').value
  iban = $('#iban').value
  bic = $('#bic').value

  $('#bank_code').focusout ->
    bank_code = this.value
    removeWarning '#user_bank_code_input'
    if bank_code isnt ''
      getBankName bank_code

  $('#bank_account_number').focusout ->
    account = this.value
    removeWarning '#user_bank_account_number_input'
    if $('#user_bank_code_input .inline-errors').length > 0
      addWarning '#user_bank_account_number_input', 'Die Kontonummer kann ohne gültige BLZ nicht überprüft werden.'
    else
      checkBankDetails account, bank_code

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


getBankName = (bank_code) ->
  $.getJSON '/bank_details/get_bank_name.json', "bank_code="+bank_code, (data) ->
    if data
      $('#bank_name').val data
      checkBankDetails account, bank_code
    else
      addWarning('#user_bank_code_input', 'Bitte Bankleitzahl überprüfen.')
      if account isnt ''
        removeWarning '#user_bank_account_number_input'
        addWarning '#user_bank_account_number_input', 'Die Kontonummer kann ohne gültige BLZ nicht überprüft werden.'

checkBankDetails = (account, bank_code) ->
  if account isnt '' and bank_code isnt ''
    bank_data = "bank_account_number="+account+"&bank_code="+bank_code
    $.getJSON '/bank_details/check.json', bank_data, (data) ->
      removeWarning '#user_bank_account_number_input'
      unless data
        addWarning '#user_bank_account_number_input', 'Bitte Kontonummer überprüfen.'

addWarning = (element, message)->
  $("<p>").appendTo(element).addClass('inline-errors').html(message)
  $('#user_bankaccount_warning').checked = true
removeWarning = (element) ->
  $(element+' .inline-errors').remove()
  $('#user_bankaccount_warning').checked = false
