$(document.body).ready(function(){
  var account = ''
  var bank_code = ''

  $('#bank_code').focusout (function() {
    bank_code = this.value
    if(bank_code != ''){
      $('#user_bank_code_input .inline-errors').remove()
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
      if(data) $('#user_bank_account_number_input .inline-errors').remove()
      else addInvalidAccountNumberWarning()
    });
  }
}

addInvalidBankCodeWarning = function(){
  $("<p>").appendTo('#user_bank_code_input').addClass('inline-errors').html('Bitte Bankleitzahl überprüfen.')
}

addInvalidAccountNumberWarning = function(){
  $('#user_bank_account_number_input .inline-errors').remove()
  $("<p>").appendTo('#user_bank_account_number_input').addClass('inline-errors').html('Bitte Kontonummer überprüfen.')
}

addAccountValidationNotPossibleWarning = function(){
  $('#user_bank_account_number_input .inline-errors').remove()
  $("<p>").appendTo('#user_bank_account_number_input').addClass('inline-errors').html('Die Kontonummer kann ohne gültige BLZ nicht überprüft werden.')
}
