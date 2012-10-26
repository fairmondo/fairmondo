Tinycms::Engine.routes.draw do
  root :to => "contents#index"
  
  resources :contents do 
    get :not_found, :on => :member
  end
end
