FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    sequence(:slug) { |n| Faker::Internet.domain_word + n.to_s }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }

    trait :with_custom_page do
      after(:create) do |organization|
        create(:custom_page, organization: organization) unless organization.custom_page
      end
    end

    trait :with_location do
      after(:create) do |organization|
        create(:location, locatable: organization)
      end
    end
  end
end
