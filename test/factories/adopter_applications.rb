FactoryBot.define do
  factory :adopter_application do
    profile_show { true }
    status { 1 }
    association :person
    association :pet

    transient do
      user { nil }
    end

    trait :adoption_pending do
      status { 2 }
    end

    trait :withdrawn do
      status { 3 }
      profile_show { false }
    end

    trait :successful_applicant do
      status { 4 }
    end
  end
end
