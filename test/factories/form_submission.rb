FactoryBot.define do
  factory :form_submission do
    # organization assigned by ActsAsTenant
    association :person
    csv_timestamp { Time.current }
  end
end
