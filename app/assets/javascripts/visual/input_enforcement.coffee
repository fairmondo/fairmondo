$ ->
  $('.JS-enforce-input-constraints').on 'keypress', (event) ->
    target = event.target
    $target = $(target)
    key = event.which
    allowed = false

    switch $target.attr 'type'
      when 'number'
        # allow only numbers
        allowed = (key >= 48 and key <= 57)
      when 'text'
        if pattern = $target.attr('data-enforcement-pattern')
          future_value = future_input_value target.value, $target.caretRange(), String.fromCharCode(key)
          allowed = future_value.match eval pattern
        else
          allowed = true
      else
        console.log "Please define rules for the input type '#{target.type}' in input_enforcement.coffee."

    unless allowed or (key is 0 or key is 8) # allow arrows, backspace, del
      event.preventDefault()
      false

  $('.JS-enforce-input-constraints').on 'keyup', (event) ->
    target = event.target

    switch $(target).attr 'type'
      when 'number'
        # JS magic: double bitwise operator is a faster parseInt
        target.value = target.max if ~~target.value > ~~target.max

  $('.JS-enforce-input-constraints').on 'blur', (event) ->
    target = event.target

    switch $(target).attr 'type'
      when 'number'
        # wait for blur to set min values, or else if the min is "5" for example it would be hard to type a "22"
        target.value = target.min if ~~target.value < ~~target.min

future_input_value = (state, caret, new_char) ->
  state.substring(0, caret.start) + new_char + state.substring(caret.end)
