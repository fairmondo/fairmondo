$(document).ready ->
  $("#slides").slidesjs
    width: 490
    height: 490
    start: Math.floor(Math.random() * 6) # random number between 0 and 5
    play:
      active: false
      auto: true
      interval: 7000
    pagination:
      active: false
    navigation:
      active: false

  $("#UserSlides").slidesjs
    height: 120
    pagination:
      active: false
    navigation:
      active: false
