FactoryBot.define do
  factory :reward do
    image { Rack::Test::UploadedFile.new('spec/fixtures/img.png') }
    user

    sequence :title do |n|
      "Award #{n}"
    end
  end
end