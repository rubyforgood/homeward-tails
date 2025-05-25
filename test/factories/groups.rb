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

    # Override to_create to use find_or_create_by
    to_create do |instance|
      found = Group.find_by(name: instance.name, organization_id: instance.organization_id)
      if found
        instance.id = found.id
        instance.instance_variable_set(:@new_record, false)
      else
        instance.save!
      end
    end
  end
end
