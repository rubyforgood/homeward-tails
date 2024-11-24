FactoryBot.define do
  factory :person do
    # organization assigned by ActsAsTenant
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }

    trait :with_phone do
      phone_number { Faker::PhoneNumber.phone_number }
    end

    trait :with_location do
      after(:create) do |person|
        create(:location, locatable: person)
      end
    end
  end
end
