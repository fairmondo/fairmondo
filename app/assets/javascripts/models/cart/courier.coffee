###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

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
