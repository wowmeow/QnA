FactoryBot.define do
  factory :answer do
    body { 'Answer text' }

    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
