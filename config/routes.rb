#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

Fairmondo::Application.routes.draw do
  post 'direct_debit_mandate/create'

  post 'direct_debit_mandate/revoke' # todo: move somewhere safe

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  concern :heartable do
    resources :hearts, only: [:create, :destroy]
  end

  concern :commentable do
    resources :comments, only: [:create, :destroy, :index], constraints: { format: 'js' }
  end

  namespace :admin do
    resources :article
    resources :user
  end

  resources :article_templates, except: [:show, :index]

  resources :mass_uploads, only: [:new, :create, :show, :update] do
    collection do
      get 'image_errors'
    end
    member do
      get 'restart'
    end
  end

  get 'exports/show'

  resources :contents

  devise_for :user, controllers: { passwords: 'passwords', registrations: 'registrations',
                                   sessions: 'sessions', confirmations: 'confirmations' }

  namespace :toolbox do
    get 'session_expired', as: 'session_expired', constraints: { format: 'json' } # JSON info about session expiration. Might be moved to a custom controller at some point.
    get 'confirm', constraints: { format: 'js' }
    get 'rss'
    get 'reload', as: 'reload'
    post 'contact/:resource_type/:resource_id', as: 'contact', action: 'contact'
    patch 'reindex/:article_id', action: 'reindex', as: 'reindex'
    get 'healthcheck'
    get 'newsletter_status', as: 'newsletter_status', constraints: { format: 'json' }
  end

  namespace :statistics do
    get 'general'
    get 'category_sales'
  end

  namespace :bank_details do
    get 'check_iban', constraints: { format: 'json' }
    get 'check_bic', constraints: { format: 'json' }
  end

  resources :articles, concerns: [:commentable] do
    member do
      get 'report'
    end
    collection do
      get 'autocomplete'
    end
  end

  resources :carts, only: [:show, :edit, :update] do
    member do
      get 'send_via_email', action: 'send_via_email'
      post 'send_via_email', action: 'send_via_email'
    end
  end
  match '/empty_cart', to: 'carts#empty_cart', as: 'empty_cart', via: :get

  resources :line_items, only: [:create, :update, :destroy]

  resources :line_item_groups, only: [:show] do
    resources :payments, only: [:create, :show]
  end

  match '/paypal/ipn_notification', to: 'payments#ipn_notification', as: 'ipn_notification', via: [:get, :post]

  resources :business_transactions, only: [:show] do
    resources :refunds, only: [:new, :create]
    get 'export', on: :collection
    get 'set_transport_ready', on: :member  # TODO: do not use or replace by POST route
  end

  get 'welcome/reconfirm_terms'
  post 'welcome/reconfirm_terms'

  get 'welcome/index'
  get 'mitunsgehen', to: 'welcome#index'

  get 'feed', to: 'welcome#feed', constraints: { format: 'rss' }

  resources :feedbacks, only: [:create, :new]

  # the user routes

  resources :users, only: [:show] do
    resources :addresses, except: [:index, :show]
    resources :libraries, except: [:new, :edit]
    resources :library_elements, only: [:create, :destroy]
    resources :ratings, only: [:create, :index] do
      get '/:line_item_group_id', to: 'ratings#new', as: 'line_item_group', on: :new
    end
    member do
      get 'profile'
      get 'contact'
    end
  end

  # library routes
  resources :libraries, only: [:index, :show],
                        concerns: [:heartable, :commentable] do
    patch 'admin_audit', on: :member

    collection do
      post 'admin_add', as: 'admin_add_to'
      delete 'admin_remove/:article_id/:exhibition_name', action: 'admin_remove', as: 'admin_remove_from'
    end
  end

  # special library #index routes
  get 'trending_libraries', to: 'libraries#index', defaults: { mode: 'trending' }
  get 'new_libraries', to: 'libraries#index', defaults: { mode: 'new' }
  get 'myfavorite_libraries', to: 'libraries#index', defaults: { mode: 'myfavorite' }

  # categories routes
  resources :categories, only: [:index, :show] do
    member do
      get 'select_category'
    end
    collection do
      get 'id_index', to: 'categories#id_index'
    end
  end

  post '/remote_validations/:model/:field/:value', to: 'remote_validations#create', as: 'remote_validation', constraints: { format: 'json' }

  root to: 'welcome#index' # Workaround for double root https://github.com/gregbell/active_admin/issues/2049

  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'

  if Rails.env.development?
    constraint = lambda { |_request| true }
  else
    constraint = lambda do |request|
      request.env['warden'].authenticate? && request.env['warden'].user.admin?
    end
  end

  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  # routes for Discourse
  get 'discourse/sso'

  # TinyCMS Routes Catchup
  scope(constraints: ->(request) do
    request.params[:id] && !['assets', 'system', 'admin', 'public', 'favicon.ico', 'favicon'].any? { |url| request.params[:id].match(/^#{url}/) }
  end) do
    get '/*id' => 'contents#show'
  end
end
