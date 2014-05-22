$(function () {
  $('select').selectBoxIt({autoWidth:false});
  $('body').on('click','span.selectboxit-container',function(e) {
    $('span.selectboxit-container').parents().css("overflow", "visible");
  });
});
