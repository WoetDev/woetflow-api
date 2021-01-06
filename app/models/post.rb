class Post < ApplicationRecord
  belongs_to :user

  validates :title, :content, :cover_url, presence: true
end
