FactoryBot.define do
  factory :link do
    name { 'Google' }
    url { 'https://www.google.com' }
    linkable { create(:question) }
  end

  trait :invalid do
    url { 'google' }
  end

  trait :when_gist do
    name { 'Gist' }
    url { 'https://gist.github.com/wowmeow/e8c48cefa2602a3d670c6eacf644b899' }
  end
end
