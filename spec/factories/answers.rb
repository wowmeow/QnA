FactoryBot.define do
  factory :answer do
    title { 'Answer title' }
    body { 'Answer text' }

    question
    user

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
