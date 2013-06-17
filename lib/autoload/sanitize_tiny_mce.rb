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
module SanitizeTinyMce
  # Sanitization specifically for tiny mce fields which allow certain HTML
  # elements.
  #
  # @api public
  # @param field [Sting] The content to sanitize
  # @return [String] The sanitized content
  def self.sanitize_tiny_mce field
    Sanitize.clean(field,
      elements: %w(a b i strong em p h1 h2 h3 h4 h5 h6 br hr ul li img),
      attributes: {
        'a' => ['href', 'type'],
        'img' => ['src'],
        :all => ['width', 'height', 'style', 'data', 'name']
      },
      protocols: {
        'a' => { 'href' => ['ftp', 'http', 'https', 'mailto'] },
        'img' => { 'src' => ['http', 'https'] }
      }
    )
  end

end
