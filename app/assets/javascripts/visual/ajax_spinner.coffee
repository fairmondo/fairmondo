###
   Copyright (c) 2012-2016, Fairmondo eG.  This file is
   licensed under the GNU Affero General Public License version 3 or later.
   See the COPYRIGHT file for details.
###

$ ->
  $(document).on
    'ajaxStart': ->
      $('.l-ajax-spinner').fadeIn 200
    'ajaxStop': ->
      $('.l-ajax-spinner').fadeOut 200
