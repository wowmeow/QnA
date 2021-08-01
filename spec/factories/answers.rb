FactoryBot.define do
  factory :answer do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
