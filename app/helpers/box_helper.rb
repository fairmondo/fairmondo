#
module BoxHelper
  # wrapps the layout call and sanitizes the options
  def render_box(box_name, options = {}, &block)
    render layout: "box_layout",
      locals: {

        box_name: box_name,
        box_title: t(box_name, :scope => "boxes.#{controller_name}"),
        box_legend_class: options[:legend_class] || "",
        tooltip_text: false,
        box_content_class: options[:content_class] || "white-well"

      }, &block
  end
end
