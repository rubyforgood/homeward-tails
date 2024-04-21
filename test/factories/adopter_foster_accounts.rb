FactoryBot.define do
  factory :adopter_foster_account do
    user { association :adopter }

    trait :with_profile do
      adopter_foster_profile do
        association :adopter_foster_profile, adopter_foster_account: instance
      end
    end
  end
end
