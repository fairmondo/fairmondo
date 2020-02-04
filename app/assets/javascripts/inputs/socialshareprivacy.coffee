###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

socialshareprivacy = ->
  if $('.socialshareprivacy').length > 0
    $('.socialshareprivacy').not('.socialshareprivacy--loaded').socialSharePrivacy()
    $('.socialshareprivacy').addClass('socialshareprivacy--loaded')

$(document).ready socialshareprivacy
