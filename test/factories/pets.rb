FactoryBot.define do
  factory :pet do
    application_paused { false }
    birth_date { Faker::Date.backward(days: 7) }
    breed { Faker::Creature::Dog.breed }
    description { Faker::Lorem.sentence }
    name { Faker::Creature::Dog.name }
    placement_type { "Adoptable and Fosterable" }
    published { true }
    sex { Faker::Creature::Dog.gender }
    species { Faker::Number.within(range: 1..2) }
    weight_from { 10 }
    weight_to { 20 }
    weight_unit { "lb" }

    trait :adoption_pending do
      adopter_applications { build_list(:adopter_application, 3, :adoption_pending, pet: instance) }
    end

    trait :adopted do
      matches { [association(:match, pet: instance, match_type: :adoption)] }
      adopter_applications { build_list(:adopter_application, 1, :successful_applicant, pet: instance) }
    end

    trait :completed_foster do
      matches {
        start = Time.current - rand(6..12).months
        [association(:match,
          pet: instance,
          match_type: :foster,
          start_date: start,
          end_date: start + rand(3..6).months)]
      }
    end

    trait :current_foster do
      transient do
        foster_person { create(:person) }
      end

      matches {
        [association(:match,
          pet: instance,
          match_type: :foster,
          person: foster_person,
          start_date: Time.current - 2.months,
          end_date: Time.current + 4.months)]
      }
    end

    trait :future_foster do
      matches {
        start = Time.current + rand(1..3).months
        [association(:match,
          pet: instance,
          match_type: :foster,
          start_date: start,
          end_date: start + rand(3..6).months)]
      }
    end

    trait :with_image do
      after(:build) do |pet|
        pet.images.attach(
          io: File.open(Rails.root.join("test", "fixtures", "files", "test.png")),
          filename: "test.png",
          content_type: "image/png"
        )
      end
    end

    trait :with_files do
      after(:build) do |pet|
        pet.files.attach(
          io: File.open(Rails.root.join("test", "fixtures", "files", "test2.png")),
          filename: "test2.png",
          content_type: "image/png"
        )
      end
    end
  end
end
