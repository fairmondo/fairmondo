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