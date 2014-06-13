require 'spec_helper'

describe AddressesController do
  describe 'routing' do
    it 'to ::new' do
      get('/users/1/addresses/new').should route_to('addresses#new', user_id: '1')
    end

    it 'to ::create' do
      post('/users/1/addresses').should route_to('addresses#create', user_id: '1')
    end

    it 'to ::edit' do
      get('/users/1/addresses/1/edit').should route_to('addresses#edit', id: '1', user_id: '1')
    end

    it 'to ::update' do
      patch('/users/1/addresses/1').should route_to('addresses#update', id: '1', user_id: '1')
    end

    it 'to ::destroy' do
      delete('/users/1/addresses/1').should route_to('addresses#destroy', id: '1', user_id: '1')
    end

    it 'to ::index' do
      get('/users/1/addresses').should route_to('addresses#index', user_id: '1')
    end
  end
end
