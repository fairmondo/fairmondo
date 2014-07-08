$ ->
  $('.JS-enforce-input-constraints').on 'keydown', (event) ->
    target = event.target
    key = event.which
    allowed = false

    switch target.type
      when 'number'
        # allow only numbers
        allowed = (key >= 48 and key <= 57)
      else
        console.log "Please define rules for the input type '#{target.type}' in input_enforcement.coffee."

    # always allow backspace, tab, delete, arrows, home, end
    if $.inArray(key, [8, 9, 46, 37,38,39,40, 36, 35]) is -1 and not allowed
      event.preventDefault()
      false

  $('.JS-enforce-input-constraints').on 'keyup', (event) ->
    target = event.target

    switch target.type
      when 'number'
        target.value = target.max unless ~~target.value <= ~~target.max and ~~target.value >= ~~target.min
