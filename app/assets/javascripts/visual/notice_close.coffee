###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

noticeClose = ->
  $('.Notice').on 'click', '.Notice-close', ->
    $(@).parent().slideUp(0)
    $(@).parent().remove()
$(document).ready noticeClose
$(document).ajaxStop noticeClose
