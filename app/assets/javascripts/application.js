//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require tinymce
//= require tinymce-jquery
//= require bootstrap
//= require autocomplete-rails

$(document).ready(function(){
	// popover
    $("#login-popover")
      .popover()
      .click(function(e) {
        e.preventDefault()
      })
      
});