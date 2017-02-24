###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

# refs #151

selectToggle = (e) ->
  area_id = $(@).attr "data-select-toggle"
  $("#" + area_id).parent().toggle(@checked)

addToggleListeners = ->
  $('input[data-select-toggle][type=checkbox]').on(
    'ifCreated ifToggled'
    selectToggle
  )
  $('input[data-select-toggle][type=radio]').on(
    'ifCreated ifToggled'
    selectToggle
  )

$(document).ready addToggleListeners
$(document).ajaxStop -> setTimeout addToggleListeners, 1 # iCheck weirdness ... an ajax event somehow unsets the listeners
