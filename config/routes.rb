Fairnopoly::Application.routes.draw do
  
  resources :auction_templates, :except => [:show, :index]

  mount Tinycms::Engine => "/cms"

  devise_for :user, controllers: { registrations: 'registrations' }

  resources :auctions do
    member do
      get 'activate'
      get 'deactivate'
      get 'report'
    end
    collection do
      get 'sunspot_failure'
      get 'autocomplete'
    end
  end

  get "welcome/index"

  #the user routes
 
  match 'dashboard' => 'dashboard#index'
<<<<<<< HEAD

  get 'dashboard/edit_profile'

  
   
  resources :users, :only => [:show,:edit] do
    resources :libraries, :except => [:new,:edit]  
    resources :library_elements, :except => [:new, :edit]
    member do
      get 'sales'
      get 'profile'
     
    end
  end
  
=======
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
>>>>>>> c26cd7ae00eeb5d479d2396a73668233a69a8e7b
   
  root :to => 'welcome#index'
  ActiveAdmin.routes(self) # Workaround for double root https://github.com/gregbell/active_admin/issues/2049

  
  # TinyCMS Routes Catchup
  scope :constraints => lambda {|request|
    request.params[:id] && !["assets","system","admin","public","favicon.ico"].any?{|url| request.params[:id].match(/^#{url}/)}
  } do
    match "/*id" => 'tinycms/contents#show'
  end
  
end
