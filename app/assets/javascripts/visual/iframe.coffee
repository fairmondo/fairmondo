#resizeIframe = (iframe) ->
#  iframe.height = (iframe.contentWindow.document.documentElement.scrollHeight || iframe.contentWindow.document.body.scrollHeight) + "px"
#  # wont resize iframe to be smaller in some browsers. but ... who needs that anyway

#document.loadIframe = (iframe) ->
#  resizeIframe iframe

#  window.onresize = (event) -> # define this on iframe load so it doesn't exist on iframe-less pages
#    resizeIframe document.getElementsByTagName("iframe")[0]
#    # change to loop should we have more than one iframe that needs this

document.Fairnopoly.placeIframe = (url) ->
  new easyXDM.Socket
    remote: url
    container: document.getElementById("WeGreen-iframe")
    props:
      style:
        scrolling: 'no'
        width: '100%'
        border: '0'
        overflow: 'hidden'
    onMessage: (message) ->
      this.container.getElementsByTagName("iframe")[0].style.height = message + "px"
