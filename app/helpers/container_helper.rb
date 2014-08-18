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
#

module ContainerHelper
  # Wraps the layout call and sanitizes the options
  #
  # @param accordion_name [String] The box's name
  # @param options [Array] Further options like :title, :legend_class, :content_class, and :openbox
  # @param block [Proc] The box's contents
  # @return [String] The compiled HTML of the box element
  def accordion_item(accordion_name, options = {}, &block)
    header_class = options[:header_class] || ""
    content_class = options[:content_class] || ""
    render layout: "accordion_layout",
      locals: {
        accordion_name: accordion_name,
        accordion_title: options[:title] || t(accordion_name, :scope => "#{controller_name}.boxes"),
        accordion_tooltip: options[:tooltip],
        accordion_header_class: header_class,
        accordion_content_class: content_class,
        accordion_item_class: options[:item_class] || '',
        accordion_arrow: options[:arrow]==false ? false : true
      }, &block
  end

  def gray_box(heading, options = {}, &block)
    render layout: "gray_box_layout",
      locals: {
        heading: heading,
        frame_class: options[:frame_class] || ""
      }, &block
  end

end
