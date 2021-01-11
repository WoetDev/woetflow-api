class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :user

  validates :title, :summary, :content, :cover_url, presence: true
end
  