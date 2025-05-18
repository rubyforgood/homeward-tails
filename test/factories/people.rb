FactoryBot.define do
  factory :person do
    # organization assigned by ActsAsTenant
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }

    after(:build) do |person, evaluator|
      person.user ||= build(:user, email: person.email, password: evaluator.user_password)
    end

    trait :with_phone do
      phone_number { Faker::PhoneNumber.phone_number }
    end

    trait :with_location do
      after(:create) do |person|
        create(:location, locatable: person)
      end
    end

    transient do
      deactivated { false }
    end

    transient do
      user_password { "123456" }  # default password, can be overridden
    end

    trait :adopter do
      after(:create) do |person, context|
        group = create(:group, :adopter)
        create(:person_group, person: person, group: group, deactivated_at: (context.deactivated ? Time.current : nil))
      end
    end

    trait :fosterer do
      after(:create) do |person, context|
        group = create(:group, :fosterer)
        create(:person_group, person: person, group: group, deactivated_at: (context.deactivated ? Time.current : nil))
      end
    end

    trait :admin do
      after(:create) do |person, context|
        group = create(:group, :admin)
        create(:person_group, person: person, group: group, deactivated_at: (context.deactivated ? Time.current : nil))
      end
    end

    trait :super_admin do
      after(:create) do |person, context|
        group = create(:group, :super_admin)
        create(:person_group, person: person, group: group, deactivated_at: (context.deactivated ? Time.current : nil))
      end
    end
  end
end
