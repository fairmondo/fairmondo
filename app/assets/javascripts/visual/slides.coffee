$(document).ready ->
  $("#slides").slidesjs
    width: 356
    height: 356
    start: ~~(Math.random() * 6) # random number between 0 and 5
    play:
      active: false
      auto: true
      interval: 7000
    pagination:
      active: false
    navigation:
      active: false

  $("#UserSlides").slidesjs
    pagination:
      active: false
    navigation:
      active: true