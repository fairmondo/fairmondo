#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
Fairnopoly::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  namespace :admin do
    resources :article
  end

  resources :article_templates, :except => [:show, :index]

  resources :mass_uploads, :only => [:new, :create, :show, :update] do
    collection do
      get 'image_errors'
    end
  end

  get 'exports/show'

  resources :contents

  devise_for :user, controllers: { registrations: 'registrations', sessions: 'sessions' }

  namespace :toolbox do
    get 'session', as: 'session', constraints: {format: 'json'} # JSON info about session expiration. Might be moved to a custom controller at some point.
    get 'confirm' , constraints: {format: 'js'}
    get 'rss'
    get 'notice/:id', action: "notice", as: 'notice'
  end

  namespace :bank_details do
    get 'check', constraints: {format: 'json'}
    get 'get_bank_name', constraints: {format: 'json'}
  end

  resources :articles do
    member do
      get 'report'
    end
    collection do
      get 'autocomplete'
    end
  end

  resources :transactions, only: [:show, :edit, :update] do
    member do
      put 'edit' => 'transactions#edit', as: :step2
      get 'already_sold'
      get 'print_order_buyer'
      #get 'print_order_seller'
    end
  end

  get "welcome/reconfirm_terms"
  post "welcome/reconfirm_terms"

  get "welcome/index"
  get "feed", to: 'welcome#feed', constraints: {format: 'rss'}

  resources :feedbacks, :only => [:create,:new]

  #the user routes

  resources :users, :only => [:show] do
    resources :libraries, :except => [:new,:edit]
    resources :library_elements, :except => [:new, :edit]
    resources :ratings, :only => [:create, :index] do
      get '/:transaction_id', to: 'ratings#new', as: 'transaction', on: :new
    end
    collection do
      get 'login'
    end
    member do
      get 'profile'
    end
  end

  resources :libraries, :only => [:index]

  resources :categories, :only => [:show]

  resources :exhibits, :only => [:create,:update]

  root :to => 'welcome#index' # Workaround for double root https://github.com/gregbell/active_admin/issues/2049

  # TinyCMS Routes Catchup
  scope :constraints => lambda {|request|
    request.params[:id] && !["assets","system","admin","public","favicon.ico", "favicon"].any?{|url| request.params[:id].match(/^#{url}/)}
  } do
    match "/*id" => 'contents#show'
  end

end
