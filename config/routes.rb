Fairnopoly::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :article_templates, :except => [:show, :index]

  mount Tinycms::Engine => "/cms"

  devise_for :user, controllers: { registrations: 'registrations' }

  resources :articles do
    member do
      get 'activate'
      get 'deactivate'
      get 'report'
    end
    collection do
      get 'autocomplete'
    end
  end

  get "welcome/index"

  #the user routes

  resources :users, :only => [:show] do
    resources :libraries, :except => [:new,:edit]
    resources :library_elements, :except => [:new, :edit]
    member do
      get 'profile'
    end
  end

  root :to => 'welcome#index' # Workaround for double root https://github.com/gregbell/active_admin/issues/2049

  # TinyCMS Routes Catchup
  scope :constraints => lambda {|request|
    request.params[:id] && !["assets","system","admin","public","favicon.ico", "favicon"].any?{|url| request.params[:id].match(/^#{url}/)}
  } do
    match "/*id" => 'tinycms/contents#show'
  end

end
