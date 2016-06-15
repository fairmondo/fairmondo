###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

$(document).ready ->
  $(".registrations-form #user_password").complexify
    strengthScaleFactor: 0.8
  , (valid, complexity) ->
    $("#js-password_complexity_progress").show()
    $("#js-password_complexity_label").show()
    bar = $ "#js-password_complexity_progress .bar"
    bar.width complexity + "%"
    if valid
      bar.addClass("bar--green").removeClass "bar--red"
    else
      bar.addClass("bar--red").removeClass "bar--green"
