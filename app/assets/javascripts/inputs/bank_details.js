$(document.body).ready(function(){
  var account = ''
  var bank_code = ''

  $('#bank_code').focusout (function() {
    bank_code = this.value
    if(bank_code != ''){
      removeInvalidBankCodeWarning()
      $.getJSON('/bank_details/get_bank_name.json', "bank_code="+bank_code, function(data) {
        if(data){
          $('#bank_name').val(data)
          $('#user_bank_name_input .inline-errors').remove()
          checkBankDetails(account, bank_code)
        } else {
            addInvalidBankCodeWarning()
            if(account != '') addAccountValidationNotPossibleWarning()
        }
      });
    }
  })

  $('#iban').focusout(function(){
	iban = this.value

  })
  $('#bic').focusout(function(){
	bic = this.value
  })

  $('#bank_name').focusout(function(){
    bank_name = this.value
    if(bank_name != '') $('#user_bank_name_input .inline-errors').remove()
  })

  $('#bank_account_number').focusout (function() {
    account = this.value
    if($('#user_bank_code_input .inline-errors').length > 0) addAccountValidationNotPossibleWarning()
    else checkBankDetails(account, bank_code)
  })

  $('#bank_account_owner').focusout(function(){
    bank_account_owner = this.value
    if(bank_account_owner != '') $('#user_bank_account_owner_input .inline-errors').remove()
  })

})


checkBankDetails = function(account, bank_code){
  if(account != '' && bank_code != ''){
    bank_data = "bank_account_number="+account+"&bank_code="+bank_code
    $.getJSON('/bank_details/check.json', bank_data, function(data) {
      if(data) removeInvalidAccountNumberWarning()
      else addInvalidAccountNumberWarning()
    });
  }
}


addInvalidIbanWarning = function(){
  $("<p>").appendTo('#user_iban_input').addClass('inline-errors').html('Bitte IBAN überprüfen.')
  $('#user_bankaccount_warning').checked = true
}
addInvalidBicWarning = function(){
  $("<p>").appendTo('#user_bic_input').addClass('inline-errors').html('Bitte BIC überprüfen.')
  $('#user_bankaccount_warning').checked = true
}
addInvalidBankCodeWarning = function(){
  $("<p>").appendTo('#user_bank_code_input').addClass('inline-errors').html('Bitte Bankleitzahl überprüfen.')
  $('#user_bankaccount_warning').checked = true
}
addInvalidAccountNumberWarning = function(){
  $('#user_bank_account_number_input .inline-errors').remove()
  $("<p>").appendTo('#user_bank_account_number_input').addClass('inline-errors').html('Bitte Kontonummer überprüfen.')
  $('#user_bankaccount_warning').checked = true
}

addAccountValidationNotPossibleWarning = function(){
  $('#user_bank_account_number_input .inline-errors').remove()
  $("<p>").appendTo('#user_bank_account_number_input').addClass('inline-errors').html('Die Kontonummer kann ohne gültige BLZ nicht überprüft werden.')
}

removeInvalidBankCodeWarning = function(){
  $('#user_bank_code_input .inline-errors').remove()
  $('#user_bankaccount_warning').checked = false
}
removeInvalidAccountNumberWarning = function(){
  $('#user_bank_account_number_input .inline-errors').remove()
  $('#user_bankaccount_warning').checked = false
}
removeInvalidIbanWarning = function(){
  $('#user_iban_input .inline-errors').remove()
  $('#user_bankaccount_warning').checked = false
}
removeInvalidBicWarning = function(){
  $('#user_bic_input .inline-errors').remove()
  $('#user_bankaccount_warning').checked = false
}
