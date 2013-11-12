
devise_expire = (60 * 60 * 1000)

calculateExpireTime = ->
  return new Date().getTime() + devise_expire

expireTime = calculateExpireTime()

checkIfExpired = ->
  if new Date().getTime() >= expireTime
    checkIfExpiredOnServer (expired) ->
      if expired
        window.clearInterval interval
        displayWarning()
      else
        expireTime = calculateExpireTime()

checkIfExpiredOnServer = (callback) ->
  $.get '/toolbox/session_expired.json', (result) ->
    callback result.expired

displayWarning = ->
  $.colorbox({
    transition: "none",
    width: "auto",
    opacity: 0.4,
    html: "<div id='inactive-msg'><p>" + I18n.t("javascript.common.session_expiring_notice") + "</p></div>"
  });

trackMouseClicks = ->
  $(window).on 'click.trackmouse', ->
     $(window).off('click.trackmouse')
     notify = window.setTimeout trackMouseClicks, ((devise_expire*4)/6)
     $.get '/toolbox/session_expired.json'



interval = window.setInterval checkIfExpired, (devise_expire/6) # every 10 min

notify = window.setTimeout trackMouseClicks, ((devise_expire*4)/6) # every 40 min
