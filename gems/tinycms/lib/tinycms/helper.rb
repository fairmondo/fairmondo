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
module Tinycms
  module Helper

    def tinycms_field(form, field_name, options={})
      config = Tinycms.tinymce_configuration.merge(options)
      config.options[:editor_selector] ||= "tinycms"
      r = form.text_area field_name.to_sym, :class => config.options[:editor_selector]
      r << "\n"
      r << javascript_tag { "tinyMCE.init(#{config.options_for_tinymce.to_json});".html_safe }
      r.html_safe
    end

    def tinycms_content(key)
      render "tinycms/contents/embed", :content => Content.find_or_create_by_key(key.to_s.parameterize)
    end


  end
end