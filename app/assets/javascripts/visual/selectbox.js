$(function () {
 $('select').selectBoxIt({autoWidth:false});
 $('select').click(function(e) {
   parents = $(e.target).parent();
   parents.css("overflow", "visible");
   parents.parents().css("overflow", "visible");
 });
});