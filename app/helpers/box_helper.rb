#
module BoxHelper
  # wrapps the layout call and sanitizes the options
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
