ActiveAdmin.register Faq do
  # fix for #103
  collection_action :index, :method => :get do
    scope = Faq.scoped
    scope.singleton_class.send(:include, Kaminari::ActiveRecordRelationMethods)
    scope.singleton_class.send(:include, Kaminari::PageScopeMethods)
        
    @collection = scope.page(1) if params[:q].blank?
    @search = scope.metasearch(clean_search_params(params[:q]))
  end
end
