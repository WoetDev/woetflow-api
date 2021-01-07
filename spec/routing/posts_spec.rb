require 'rails_helper'

describe 'posts routes' do
  it 'should route GET posts to the index action' do
    expect(get '/posts').to route_to('posts#index')
  end

  it 'should route POST posts to the create action' do
    expect(post '/posts').to route_to('posts#create')
  end

  it 'should route PATCH posts to the update action' do
    expect(put '/posts/1').to route_to('posts#update', id: '1')
    expect(patch '/posts/1').to route_to('posts#update', id: '1')
  end

  it 'should route DELETE posts to the destroy action' do
    expect(delete '/posts/1').to route_to('posts#destroy', id: '1')
  end
end