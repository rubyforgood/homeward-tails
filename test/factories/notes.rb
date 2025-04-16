FactoryBot.define do
  factory :note do
    notes { "Test notes content" }
    association :organization

    # For polymorphic association, default to application
    trait :for_application do
      association :notable, factory: :adopter_application
    end

    trait :for_fosterer do
      association :notable, factory: :fosterer
    end
  end
end
