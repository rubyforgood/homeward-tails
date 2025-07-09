FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "123456" }
    encrypted_password { Devise::Encryptor.digest(User, "123456") }
    tos_agreement { true }

    trait :with_avatar do
      after(:build) do |user|
        user.avatar.attach(
          io: File.open(Rails.root.join("test", "fixtures", "files", "test.png")),
          filename: "test.png",
          content_type: "image/png"
        )
      end
    end
  end
end
