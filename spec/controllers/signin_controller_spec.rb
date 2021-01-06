require 'rails_helper'

RSpec.describe SigninController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:correct_password) { 'secret' }
    let(:user_params) { { full_name: user.full_name, password: correct_password } }

    it 'returns http success' do
      post :create, params: user_params
      expect(response).to have_http_status(:ok)
      expect(response_json.keys).to eq ['csrf']
      expect(response.cookies[JWTSessions.access_cookie]).to be_present
    end

    it 'returns unauthorized for invalid params' do
      post :create, params: { full_name: user.full_name, password: 'incorrect' }
      expect(response).to have_http_status(401)
    end
  end
end