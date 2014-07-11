$ ->
  $('.JS-remote-validate-blur').on 'blur', validate_remotely

validate_remotely = (event) ->
  setTimeout -> # to allow JS-enforce-input-constraints to do it's thang
    target = event.target
    $target = $(target)
    params_from_name = target.name.slice(0, -1).split('[') # e.g. line_item[requested_quantity] => ['line_item', 'requested_quantity']
    value = target.value
    unless value is $target.attr('data-validation-allow') or value is '' # allow specific inputs. maybe make this regex compatible
      model = params_from_name[0]
      field = params_from_name[1]
      additional_params = $target.attr('data-validation-params')
      additional_params = if additional_params then "?#{additional_params}" else ''

      $.post "/remote_validations/#{model}/#{field}/#{value}.json#{additional_params}", (response) ->
        # reset in case error messages get chained
        $target.parent().removeClass 'error'
        $target.siblings('.inline-errors').remove()

        # add an error message if one exists
        if response.errors.length > 0
          $.each response.errors, (index, error) -> console.log "#{target.name}: #{error}"
          error_message = response.errors[0]
          error_message += $target.attr('data-validation-error-addition') if $target.attr('data-validation-error-addition') # optional
          $target.parent().addClass 'error'
          $target.after "<p class='inline-errors'>#{error_message}</p>"

  , 1 # setTimeout: 1 millisecond wait
