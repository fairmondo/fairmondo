ActiveAdmin.register Tinycms::Content do
  
  form :partial => "form"
=begin
    form do |f|
      f.inputs "CMS" do
        if  f.object.new_record?
          f.inputs "URL" do
            f.input :key
          end
        end
        f.inputs "Content" do
          f.input :body, :input_html => { :class => "tinymce" }
        end
      end
      f.buttons
    end
=end
end
