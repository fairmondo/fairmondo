#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
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
    render layout: "/application/notice_layout", locals: { type: :confirm} do
      concat("<p class=\"confirmation_message\"></p>".html_safe)
      concat("<a class=\"Button Button--red confirm\" >  #{confirm_text} </a> ".html_safe)
      concat("<a class=\"Button cancel\"  > #{cancel_text} </a>".html_safe)
    end
  end

  def render_open_notice notice
    continue_text = I18n.t('common.actions.continue')
    message = "<p class=\"confirmation_message\">#{notice.message}</p>".html_safe
    message += "<a class=\"Button\" href=\"#{toolbox_notice_path(:id => notice.id)}\">#{continue_text}</a>".html_safe
  end

end
