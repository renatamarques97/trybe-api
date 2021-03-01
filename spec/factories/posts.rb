FactoryBot.define do
  factory :post do
    title { "Title" }
    content { "Content" }
    user
  end
end
