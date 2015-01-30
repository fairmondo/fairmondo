createSliders = ->
  # disable hoverpause in slider settings because it is irritating on touch
  # devices

  $('#billboard .slider').glide
    autoplay: 10000
    hoverpause: false
    navigation: false
    arrowLeftText: null
    arrowRightText: null

  $('#cardslides .slider').glide
    autoplay: 10000
    hoverpause: false
    navigation: false
    arrowLeftText: null
    arrowRightText: null

  $('#userslides .slider').glide
    autoplay: false
    hoverpause: false
    navigation: false
    arrowLeftText: null
    arrowRightText: null


$(document).always createSliders
