require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    it 'should have valid factory' do
      user = build :user
      expect(user).to be_valid
    end

    it 'should validate presence of attributes' do
      user = build :user, full_name: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:full_name]).to include("can't be blank")
    end

    it 'should validate uniqueness of name' do
      # Create returns a saved User instance
      user = create :user

      # Build returns a User instance that's not saved
      other_user = build :user, full_name: user.full_name

      expect(other_user).not_to be_valid
      other_user.full_name = "Other Name"
      expect(other_user).to be_valid
    end
  end
end
