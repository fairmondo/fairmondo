###
   Copyright (c) 2012-2017, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

createSliders = ->
  $("#js-billboardslides").slidesjs
    width: 205
    height: 410
    play:
      active: false
      auto: true
      interval: 10000
    pagination:
      active: false
    navigation:
      active: false

  $("#js-cardslides").slidesjs
    width: 490
    height: 490
    start: Math.floor(Math.random() * 5)+1  # random number between 1 and 5
    play:
      active: false
      auto: true
      interval: 10000
    pagination:
      active: false
    navigation:
      active: false

  $("#js-userslides").slidesjs
    start: Math.floor(Math.random() * 5)+1  # random number between 1 and 5
    pagination:
      active: false
    navigation:
      active: false
    callback:
      loaded: (n) ->
        $("#slide#{n}").css('position', 'static')
      complete: (n) ->
        m = if (n-1) == 0 then 5 else (n-1)
        o = if (n+1) == 6 then 1 else (n+1)
        $("#slide#{m}").css('position', 'absolute')
        $("#slide#{n}").css('position', 'static')
        $("#slide#{o}").css('position', 'absolute')

$(document).ready createSliders
