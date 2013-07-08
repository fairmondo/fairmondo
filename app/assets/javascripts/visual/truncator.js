$(document).ready(function(){
      $('div[data-truncate]').each(function(index,element) {
      	$(element).truncate({max_length: $(element).data("truncate"), more: I18n.t("javascript.truncate.more"),less: I18n.t("javascript.truncate.less")});
      });

    });