FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "123456" }
    encrypted_password { Devise::Encryptor.digest(User, "123456") }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    tos_agreement { true }
    deactivated_at { nil }

    trait :with_avatar do
      after(:build) do |user|
        user.avatar.attach(
          io: File.open(Rails.root.join("test", "fixtures", "files", "test.png")),
          filename: "test.png",
          content_type: "image/png"
        )
      end
    end

    trait :deactivated do
      deactivated_at { DateTime.now }
    end

    factory :adopter do
      after(:create) do |user, _context|
        user.add_role(:adopter, user.organization)
        create(:form_submission, person: user.person)
      end
    end

    factory :fosterer do
      after(:build) do |user, _context|
        user.add_role(:fosterer, user.organization)
      end
    end

    factory :adopter_fosterer do
      after(:build) do |user, _context|
        user.add_role(:adopter, user.organization)
        user.add_role(:fosterer, user.organization)
      end
    end

    factory :admin do
      after(:build) do |user, _context|
        user.add_role(:admin, user.organization)
      end
    end

    factory :super_admin do
      after(:build) do |user, _context|
        user.add_role(:super_admin, user.organization)
      end
    end
  end
end
