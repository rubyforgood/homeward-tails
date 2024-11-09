FactoryBot.define do
  factory :match do
    pet { association :pet }
    person { association :person }
    match_type { :adoption }

    factory :foster do
      pet { association :pet, placement_type: "Fosterable" }
      match_type { :foster }
      person { association :person } # Foster person
      start_date { Faker::Time.between(from: 1.year.ago, to: 1.month.from_now) }
      end_date { start_date + rand(3..6).months }
    end

    trait :adoption do
      match_type { :adoption }
      start_date { Faker::Time.between(from: 1.year.ago, to: 1.day.ago) }
      end_date { 1.day.from_now }
    end
  end
end
