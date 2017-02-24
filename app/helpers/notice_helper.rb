#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module NoticeHelper
  def main_notice_mapper(type)
    case type
    when 'alert'
      'error'
    when 'error'
      'error'
    when 'notice'
      'info'
    when 'confirm'
      'confirmation'
    else
      'info'
    end
  end

  def render_data_confirm
    confirm_text = I18n.t('common.text.confirm_yes')
    cancel_text  = I18n.t('common.text.confirm_no')
    render layout: '/application/notice_layout', locals: { type: 'confirm' } do
      concat("<p class=\"confirmation_message\"></p>".html_safe)
      concat("<a class=\"Button Button--red confirm\" >  #{confirm_text} </a> ".html_safe)
      concat("<a class=\"Button cancel\"  > #{cancel_text} </a>".html_safe)
    end
  end
end
