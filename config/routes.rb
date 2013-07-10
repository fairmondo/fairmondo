#
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
    resources :articles
  end

  resources :article_templates, :except => [:show, :index]

  resources :mass_uploads, :only => [:new, :create, :show]

  mount Tinycms::Engine => "/cms"

  devise_for :user, controllers: { registrations: 'registrations',sessions: 'sessions' }

  namespace :toolbox do
    get 'session', as: 'session', constraints: {format: 'json'} # JSON info about session expiration. Might be moved to a custom controller at some point.
  end

  resources :articles do
    member do
      get 'report'
    end
    collection do
      get 'autocomplete'
    end
  end

  get "welcome/index"

  resources :feedbacks, :only => [:create,:new]

  #the user routes

  resources :users, :only => [:show] do
    resources :libraries, :except => [:new,:edit]
    resources :library_elements, :except => [:new, :edit]
    collection do
      get 'login'
    end
    member do
      get 'profile'
    end
  end

  resources :libraries, :only => [:index]

  resources :categories, :only => [:show]

  root :to => 'welcome#index' # Workaround for double root https://github.com/gregbell/active_admin/issues/2049

  # TinyCMS Routes Catchup
  scope :constraints => lambda {|request|
    request.params[:id] && !["assets","system","admin","public","favicon.ico", "favicon"].any?{|url| request.params[:id].match(/^#{url}/)}
  } do
    match "/*id" => 'tinycms/contents#show'
  end

end
