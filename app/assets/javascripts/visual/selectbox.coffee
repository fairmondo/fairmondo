###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

document.Fairmondo.selectboxit = ->
  $('select').selectBoxIt
    autoWidth: false
  $('body').on 'click', 'span.selectboxit-container', (e) ->
    $('span.selectboxit-container').parents().not('#cboxLoadedContent').css('overflow', 'visible')

$(document).ready document.Fairmondo.selectboxit
$(document).ajaxStop document.Fairmondo.selectboxit
