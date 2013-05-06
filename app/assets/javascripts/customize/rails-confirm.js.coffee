$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look bellow for implementations
  false # always stops the action since code runs asynchronously
 
$.rails.confirmed = (link) ->
  link.removeAttr('data-confirm')
  link.trigger('click.rails')
  
$.rails.showConfirmDialog = (link) ->
  html = link.attr('data-confirm')
  $('body').scrollTop(0);
  $('#notice .confirmation').show().removeClass("hide");
  $('#notice .confirmation_message').html(html)
  $('#notice .confirm').on 'click', -> 
    $.rails.confirmed(link)
  $('#notice .cancel').on 'click', -> 
    $('#notice .confirmation').hide();
      