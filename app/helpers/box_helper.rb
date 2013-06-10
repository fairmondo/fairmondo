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
module BoxHelper

  # Wraps the layout call and sanitizes the options
  #
  # @param box_name [String] The box's name
  # @param options [Array] Further options like :title, :legend_class, :content_class, and :openbox
  # @param block [Proc] The box's contents
  # @return [String] The compiled HTML of the box element
  def render_box(box_name, options = {}, &block)
    main_layout =  (options[:openbox] ? "box-open" : "box" )
    render layout: "box_layout",

      locals: {
        box_name: box_name,
        box_title: options[:title] || t(box_name, :scope => "#{controller_name}.boxes"),
        box_legend_class: options[:legend_class] || "",
        tooltip_text: false,
        box_content_class:  (options[:content_class] || "white-well"),
        box_layout: main_layout
      }, &block
  end

  def render_box_open(box_name, options = {}, &block)
    options[:openbox] = true
    render_box box_name,options, &block
  end
end
