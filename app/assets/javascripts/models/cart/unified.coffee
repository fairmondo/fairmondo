
unifiedTransportToggle = (e) ->
  $(e.target).parents('.js-unified-toggle-group').find('.js-unified-transport--target').toggle(!@checked)
  $(e.target).parents('.js-unified-toggle-group').find('.js-unified-transport--inversetarget').toggle(@checked)

unifiedPaymentToggle = (e) ->
  $(e.target).parents('.js-unified-toggle-group').find('.js-unified-payment--target').toggle(!@checked)

addUnifiedToggleListeners = ->
  $('input.js-unified-transport--trigger[type=checkbox]').on 'ifCreated ifToggled', unifiedTransportToggle
  $('input.js-unified-payment--trigger[type=checkbox]').on 'ifCreated ifToggled', unifiedPaymentToggle

$(document).ready addUnifiedToggleListeners
$(document).ajaxStop -> setTimeout addUnifiedToggleListeners,1