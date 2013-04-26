Fairnopoly::Application.routes.draw do
  
  resources :auction_templates, :except => [:show, :index]

  mount Tinycms::Engine => "/cms"

  devise_for :user, controllers: { registrations: 'registrations' }

  resources :auctions do
    member do
      get 'activate'
      get 'deactivate'
      get 'report'
      post 'follow'
      post 'stop_follow'
      post 'collect'
      post 'add_to_library'
    end
    collection do
      get 'sunspot_failure'
      get 'autocomplete'
    end
  end

  get "welcome/index"

  #the user routes
 
  match 'dashboard' => 'dashboard#index'
  get 'dashboard/profile'
  get 'dashboard/sales' 
  get 'dashboard/libraries'
  post 'dashboard/add_to_library'
  post 'dashboard/new_library'
  get 'dashboard/delete_library_element'
  get 'dashboard/delete_library'
  get 'dashboard/delete_library_flash'
  post 'dashboard/rename_library'
  get 'dashboard/set_library_public' 
  get 'dashboard/set_library_private' 
   
  root :to => 'welcome#index'
  ActiveAdmin.routes(self) # Workaround for double root https://github.com/gregbell/active_admin/issues/2049

  
  # TinyCMS Routes Catchup
  scope :constraints => lambda {|request|
    request.params[:id] && !["assets","system","admin","public","favicon.ico"].any?{|url| request.params[:id].match(/^#{url}/)}
  } do
    match "/*id" => 'tinycms/contents#show'
  end
  
end
