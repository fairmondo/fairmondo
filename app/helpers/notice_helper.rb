#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module NoticeHelper

  def main_notice_mapper(type)
    case type
    when :alert
      "error"
    when :error
      "error"
    when :notice
      "info"
    when :confirm
      "info confirmation"
    else
      "info"
    end
  end

  # Choose between :alert, :error, :notice for type
  def render_notice options = {}, &block
    render layout: "notice_layout",
      locals: {
        type: options[:type],
        hide: ""
      }, &block
  end

  def render_data_confirm
    confirm_icon = glyphicons('icon-trash')
    confirm_text = I18n.t('common.text.confirm_yes')
    cancel_text  = I18n.t('common.text.confirm_no')
    render layout: "notice_layout", locals: { type: :confirm, hide: "hide"} do
      concat("<p class=\"confirmation_message\"></p>".html_safe)
      concat("<button class=\"btn btn-danger confirm\" > #{confirm_icon} #{confirm_text} </button>".html_safe)
      concat("<button class=\"btn cancel\"  > #{cancel_text} </button>".html_safe)
    end
  end

end