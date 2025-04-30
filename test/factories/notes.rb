FactoryBot.define do
  factory :note do
    content { "Test notes content" }
    association :organization

    trait :for_application do
      association :notable, factory: :adopter_application
    end

    trait :for_fosterer do
      association :notable, factory: :fosterer
    end
  end
end
