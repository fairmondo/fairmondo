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
module ContentHelper

  def tinycms_content(key)
    render "contents/embed", :content => find_content(key)
  end

  def tinycms_content_body(key)
    content = find_content(key)
    content.present? ? content.body : ""
  end

  def find_content key
    Content.find_or_create_by_key(key.to_s.parameterize)
  end

  def tinycms_content_body_sanitized(key)
     Sanitize.clean(tinycms_content_body(key))
  end

end
