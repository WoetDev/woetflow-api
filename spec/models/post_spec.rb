require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { build :user }

  describe '#validations' do
    it 'should have a valid factory' do
      post = build :post
      expect(post).to be_valid
    end

    it 'should validate presence of attributes' do
      post = build :post, title: nil, content: nil, cover_url: nil, user: user
      expect(post).not_to be_valid
      expect(post.errors.messages[:title]).to include("can't be blank")
      expect(post.errors.messages[:content]).to include("can't be blank")
      expect(post.errors.messages[:cover_url]).to include("can't be blank")
    end
  end
end
