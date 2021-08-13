FactoryBot.define do
  factory :question do
    title { 'Question title' }
    body { 'Question text' }
    user

    trait :invalid do
      title { nil }
    end
  end
end
