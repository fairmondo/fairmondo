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
#
module AccordionHelper
  # wrapps the layout call and sanitizes the options
  def accordion_item(accordion_name, options = {}, &block)
    header_class = options[:header_class] || ""
    header_class += "Btn-accordion--number" if options.has_key? :number
    render layout: "accordion_layout",
      locals: {
        accordion_name: accordion_name,
        accordion_title: options[:title] || t(accordion_name, :scope => "#{controller_name}.boxes"),
        accordion_number: options[:number],
        accordion_tooltip: options[:tooltip],
        accordion_header_class: header_class
      }, &block
  end





end
