FactoryBot.define do
  factory :form_answer do
    value { JSON.dump Faker::Lorem.sentence }
    question_snapshot { Faker::Lorem.question }
  end
end
