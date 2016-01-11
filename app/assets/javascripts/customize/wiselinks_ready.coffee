###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

# Wiselinks doesn't trigger $(document).ready. Use $(document).always for methods that need to be called on every page change
# see https://github.com/igor-alexandrov/wiselinks/issues/41
jQuery.fn.extend
  always: (callback) ->
    @each ->
      $(@).ready ->
        callback()
        $(@).off('page:always', callback).on('page:always', callback)
