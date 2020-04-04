FactoryBot.define do
  factory :normal_user, class: User do
    sequence(:name) { |n| "TEST_NAME#{n}"}
    sequence(:email) { |n| "TEST#{n}@example.com"}
    sequence(:team) { |n| "team#{n}"}
    sequence(:password) { |n| "#{n}#{n}#{n}#{n}#{n}#{n}"}
  end
  
  factory :admin_user, class: User do
    name { "今井翔太" }
    email { "changemymind6@gmial.com" }
    password { "111111" }
    admin { true }
  end
  
  
end