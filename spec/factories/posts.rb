FactoryBot.define do
  factory :post do
    title { "Cool title" }
    content { "Awesome article body" }
    cover_url { "http://example.com/image" }
    association :user
  end
end
