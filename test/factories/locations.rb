FactoryBot.define do
  factory :location do
    city_town { Faker::Address.city }
    sequence(:country) { |n| "Country#{n}" }
    province_state { Faker::Address.state }
    zipcode { Faker::Address.zip_code }

    trait :for_person do
      association :locatable, factory: :person
    end

    trait :for_organization do
      association :locatable, factory: :organization
    end
  end
end
