require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }

  let(:valid_attributes) {
    { 
      title: 'new title',
      summary: 'short description about the post',
      content: 'new content',
      cover_url: 'http://example.com/image'
    }
  }

  let(:invalid_attributes) {
    { 
      title: nil,
      summary: nil,
      content: nil,
      slug: nil,
      cover_url: nil
    }
  }

  before do
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    @tokens = session.login
  end

  describe 'GET #index' do
    let!(:post) { create(:post, user: user) }

    it 'authorized without cookie' do
      get :index
      expect(response).to have_http_status(200)
    end
    
    it 'returns a success response' do      
      get :index
      expect(response).to be_successful
      expect(response_json.size).to eq 1
      expect(response_json.first['id']).to eq post.id
    end
  end

  describe 'GET #show' do
    let!(:post) { create(:post, user: user) }

    it 'returns a success response' do
      get :show, params: { id: post.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do

    context 'with valid params' do
      it 'creates a new post' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        expect {
          post :create, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)
      end

      it 'renders a JSON response with the new post' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        post :create, params: { post: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        expect(response.location).to eq(post_url(Post.last))
      end

      it 'unauthorized without CSRF' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        post :create, params: { post: valid_attributes }
        expect(response).to have_http_status(401)
      end

      it 'unauthorized without Cookie' do
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        post :create, params: { post: valid_attributes }
        expect(response).to have_http_status(401)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new post' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        post :create, params: { post: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(response_json['errors']['title']).to include("can't be blank")
        expect(response_json['errors']['summary']).to include("can't be blank")
        expect(response_json['errors']['content']).to include("can't be blank")
        expect(response_json['errors']['cover_url']).to include("can't be blank")
      end
    end
  end

  describe 'PUT #update' do
    let!(:post) { create(:post, user: user) }

    context 'with valid params' do
      let(:new_attributes) {
        { title: 'Super secret title' }
      }

      it 'updates the requested post' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        put :update, params: { id: post.id, post: new_attributes }
        post.reload
        expect(post.title).to eq new_attributes[:title]
      end

      it 'renders a JSON response with the post' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        put :update, params: { id: post.to_param, post: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the post' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        put :update, params: { id: post.to_param, post: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(response_json['errors']['title']).to include("can't be blank")
        expect(response_json['errors']['summary']).to include("can't be blank")
        expect(response_json['errors']['content']).to include("can't be blank")
        expect(response_json['errors']['cover_url']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:post) { create(:post, user: user) }

    it 'destroys the requested post' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
      expect {
        delete :destroy, params: { id: post.id }
      }.to change(Post, :count).by(-1)
    end

    it 'unauthorized without CSRF' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      expect {
        delete :destroy, params: { id: post.id }
      }.to change(Post, :count).by(0)
      expect(response).to have_http_status(401)
    end

    it 'unauthorized without Cookie' do
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
      expect {
        delete :destroy, params: { id: post.id }
      }.to change(Post, :count).by(0)
      expect(response).to have_http_status(401)
    end
  end
end