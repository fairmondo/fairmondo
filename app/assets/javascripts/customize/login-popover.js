
// refs #114
// To fix this, the element has to be on the page when it is loaded and not in a
// data-content attribute.
// But there is no way to make bootstrap actually move elements, thus
// we have to do it our own.

var parent = null;
var child = null;
var popover_just_added = true;

$(document).ready(function(){
	// popover
    $("#login-popover")
      .popover({
      	html: true,
        content: function(e) {
        	parent = document.getElementById('user-login-form');
        	child =  document.getElementById('new_user');
        	popover_just_added = true
        	parent.removeChild(child);
        	return child }
      })
      .click(function(e) {
      	if(! popover_just_added) {
      	  parent.appendChild(child);
      	}
    	popover_just_added = false;
        e.preventDefault()
      })

});