###
   Copyright (c) 2012-2015, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

truncate = ->
  $('div[data-truncate]').each (index,element) ->
    $(element).truncate
      max_length: $(element).data "truncate"
      more: I18n.t "javascript.truncate.more"
      less: I18n.t "javascript.truncate.less"

$(document).ready truncate
$(document).ajaxStop truncate
