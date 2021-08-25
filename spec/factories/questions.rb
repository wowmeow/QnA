FactoryBot.define do
  factory :question do
    title { 'Question title' }
    body { 'Question text' }
    user

    trait :invalid do
      title { nil }
      body { nil }
    end

    trait :with_file do
      after :create do |question|
        question.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')
      end
    end
  end
end
