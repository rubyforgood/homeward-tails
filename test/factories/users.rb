FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "123456" }
    encrypted_password { Devise::Encryptor.digest(User, "123456") }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    tos_agreement { true }

    # after(:create) do |user, _context|
    #   create(:person, user: user, first_name: user.first_name, last_name: user.last_name, email: user.email, user_id: user.id)
    # end

    trait :with_avatar do
      after(:build) do |user|
        user.avatar.attach(
          io: File.open(Rails.root.join("test", "fixtures", "files", "test.png")),
          filename: "test.png",
          content_type: "image/png"
        )
      end
    end

    trait :adopter do
      after(:create) do |user|
        user.add_role(:adopter, ActsAsTenant.current_tenant)
      end
    end

    trait :fosterer do
      after(:create) do |user|
        user.add_role(:fosterer, ActsAsTenant.current_tenant)
      end
    end

    trait :admin do
      after(:create) do |user|
        user.add_role(:admin, ActsAsTenant.current_tenant)
      end
    end

    trait :super_admin do
      after(:create) do |user|
        user.add_role(:super_admin, ActsAsTenant.current_tenant)
      end
    end
  end
end
