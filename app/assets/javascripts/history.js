// This script enables the browser's back and forward buttons for
// Ajax content

$(function () {
  $(window).bind("popstate", function () {
    $.getScript(location.href);
  });
})
