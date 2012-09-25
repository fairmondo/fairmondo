Fairnopoly::Application.routes.draw do

  get "invitation/index"

  resources :categories
  resources :images
  resources :userevents
  resources :events
  resources :invitations
  resources :ffps
  #recources :user

# FIXME Not working!
  resources :users do
    get :autocomplete_user_name, :on => :collection
  end

  devise_for :user

  resources :auctions do
  #recources :userevents
    get :autocomplete_auction_title, :on => :collection
  end

  get "welcome/index"
  match "continue_creating_auction" => 'auctions#finalize'

  #the user routes
  match 'dashboard' => 'dashboard#index'
  # the user routes
  match 'timeline_dashboard' => 'dashboard#timeline'
  match 'friends_dashboard' => 'dashboard#friends'
  match 'community_dashboard' => 'dashboard#community'
  match 'edit_profile_dashboard' => 'dashboard#edit_profile'
  match 'setting_dashboard' => 'dashboard#setting'
  match 'trade_dashboard' => 'dashboard#trade'
  match 'admin_dashboard' => 'dashboard#admin'

  #confirmation invitation
  match 'confirm_invitation' => 'invitations#confirm'

  match 'event' => 'userevents#index'

  match 'invitation' => 'invitations#new'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'

#root :to => 'dashboard#index'

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id))(.:format)'
end
