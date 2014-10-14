# Wiselinks doesn't trigger $(document).ready. Use $(document).always for methods that need to be called on every page change
# see https://github.com/igor-alexandrov/wiselinks/issues/41
jQuery.fn.extend
  always: (callback) ->
    @each ->
      $(@).ready ->
        callback()
        $(@).on 'page:done', callback
