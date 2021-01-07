require 'rails_helper'

describe 'refresh routes' do
  it 'should route POST refresh to the create action' do
    expect(post '/refresh').to route_to('refresh#create')
  end
end