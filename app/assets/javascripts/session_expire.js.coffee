startTime = new Date().getTime()
expireTime = startTime + (60 * 60 * 1000)

checkIfExpired = ->
  if new Date().getTime() >= expireTime
    checkIfExpiredOnServer (expired) ->
      if expired
        window.clearInterval interval
        displayWarning()

checkIfExpiredOnServer = (callback) ->
  $.get '/toolbox/session.json', (result) ->
    callback result.expired

displayWarning = ->
  $.colorbox({
    transition: "none",
    width: "auto",
    opacity: 0.4,
    html: "<div id='inactive-msg'><p>" + I18n.t("javascript.common.session_expiring_notice") + "</p></div>"
  });

interval = window.setInterval checkIfExpired, 600000 # every 10 min
