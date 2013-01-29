ActiveAdmin.register Category do
  form do |f|
      f.inputs "Category" do
        f.input :name
        f.input :desc, :label => "Optional Description"
        f.input :parent_id, :as => :select, :collection => Category.all, :include_blank => true
      end
      f.actions
    end
end
