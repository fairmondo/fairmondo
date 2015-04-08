#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
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
    render layout: '/application/notice_layout', locals: { type: 'confirm' } do
      concat("<p class=\"confirmation_message\"></p>".html_safe)
      concat("<a class=\"Button Button--red confirm\" >  #{confirm_text} </a> ".html_safe)
      concat("<a class=\"Button cancel\"  > #{cancel_text} </a>".html_safe)
    end
  end

end
