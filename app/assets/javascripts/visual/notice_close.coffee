###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

$(document).ready setNoticeClickHandler
$(document).ajaxStop setNoticeClickHandler

setNoticeClickHandler = ->
  $('.Notice').on 'click', '.Notice-close', onClickCloseButton

onClickCloseButton = (event) ->
  $(@)
    .parent()
    .slideUp(0)
    .remove()
