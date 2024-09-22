FactoryBot.define do
  factory :person do
    # organization assigned by ActsAsTenant
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }

    trait :with_phone do
      phone { Faker::PhoneNumber.phone_number }
    end
  end
end
