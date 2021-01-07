require 'rails_helper'

describe 'signin routes' do
  it 'should route POST signin to the create action' do
    expect(post '/signin').to route_to('signin#create')
  end

  it 'should route DELETE signin to the destroy action' do
    expect(delete '/signin').to route_to('signin#destroy')
  end
end