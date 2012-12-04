ActiveAdmin.register Category do
  form do |f|
      f.inputs "Category" do
        f.input :name
        f.input :desc, :label => "Optional Description"
        f.input :level , :as => :select,  :collection => {"1"=> 0,"2"=>1,"3"=>2}
        f.input :parent_id, :as => :select, :collection => Category.all
      end
      f.actions
    end
end
