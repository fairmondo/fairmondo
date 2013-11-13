$(document).ready ->
  $("#slides").slidesjs
    width: 356
    height: 356
    start: Math.floor(Math.random() * 6) # random number between 0 and 5
    play:
      active: false
      auto: true
    pagination:
      active: false
    navigation:
      active: false
