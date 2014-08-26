
unifiedTransportToggle = (e) ->
  toggle_group = $(e.target).parents('.js-unified-toggle-group')
  toggle_group.find('.js-unified-transport--target').toggle(!@checked)
  toggle_group.find('.js-unified-transport--inversetarget').toggle(@checked)

unifiedTransportAttributeToggle = (e) -> #doesnt get called on opage load
  $(e.target).parents('.js-unified-toggle-group').find('.line_item').each (index, element) ->
    if $(element).attr('data-unifiable-transport') is 'true'
      state = $(element).attr('data-unified-transport')
      $(element).attr('data-unified-transport', if state is 'true' then 'false' else 'true')

unifiedPaymentToggle = (e) ->
  $(e.target).parents('.js-unified-toggle-group').find('.js-unified-payment--target').toggle(!@checked)

addUnifiedToggleListeners = ->
  $('input.js-unified-transport--trigger[type=checkbox]').on 'ifCreated ifToggled', unifiedTransportToggle
  $('input.js-unified-transport--trigger[type=checkbox]').on 'ifToggled', unifiedTransportAttributeToggle
  $('input.js-unified-payment--trigger[type=checkbox]').on 'ifCreated ifToggled', unifiedPaymentToggle

$(document).ready addUnifiedToggleListeners
$(document).ajaxStop -> setTimeout addUnifiedToggleListeners,1