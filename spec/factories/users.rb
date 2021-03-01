FactoryBot.define do
  factory :user do
    email { "user@email.com" }
    password { "123456" }
    displayName { "commom user" }
    image { "http://4.bp.blogspot.com/_YA50adQ-7vQ/S1gfR_6ufpI/AAAAAAAAAAk/1ErJGgRWZDg/S45/brett.png" }
  end
end
