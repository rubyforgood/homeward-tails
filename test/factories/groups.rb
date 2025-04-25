FactoryBot.define do
  factory :group do
    # organization assigned by ActsAsTenant

    trait :adopter do
      name { "adopter" }
    end

    trait :fosterer do
      name { "fosterer" }
    end

    trait :admin do
      name { "admin" }
    end

    trait :super_admin do
      name { "super_admin" }
    end
  end
end
