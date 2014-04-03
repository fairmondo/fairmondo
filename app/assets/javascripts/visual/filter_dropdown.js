$( "li"  ).click(function() {
  $( ".Replace-me"  ).replaceWith( "<div class='Replace-me'>" + $( this  ).text() + "</div>"  );
});
