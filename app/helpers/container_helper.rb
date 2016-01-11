#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module ContainerHelper
  # Wraps the layout call and sanitizes the options
  #
  # @param accordion_name [String] The box's name
  # @param options [Array] Further options like :title, :legend_class, :content_class, and :openbox
  # @param block [Proc] The box's contents
  # @return [String] The compiled HTML of the box element
  def accordion_item(accordion_name, options = {}, &block)
    header_class = options[:header_class] || ''
    content_class = options[:content_class] || ''
    render layout: 'accordion_layout',
           locals: {
             accordion_name: accordion_name,
             accordion_title: options[:title] || t(accordion_name, scope: "#{controller_name}.boxes"),
             accordion_tooltip: options[:tooltip],
             accordion_header_class: header_class,
             accordion_content_class: content_class,
             accordion_item_class: options[:item_class] || '',
             accordion_arrow: options[:arrow] == false ? false : true
           }, &block
  end

  def gray_box(heading, options = {}, &block)
    render layout: 'gray_box_layout',
           locals: {
             heading: heading,
             frame_class: options[:frame_class] || '',
             title_addition: options[:title_addition]
           }, &block
  end
end
