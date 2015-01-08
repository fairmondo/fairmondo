$ ->
  $('fieldset.transport select').on('change', (e, object) ->
    parent  = $(e.target).closest('.line_item')
    courier = parent.next('.courier_step--target')
    value   = object.selectboxOption[0].value

    if (value == 'bike_courier')
      courier.show()
    else
      courier.hide()
  )
