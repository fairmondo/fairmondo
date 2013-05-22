FactoryGirl.define do
  factory :image do
    sequence(:image_file_name) {|n| "image#{n}"}
    image_content_type    "image/png"
    image_file_size       { Random.new.rand(0..5) }

    factory :fixture_image do |f|
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.png'), 'image/png') }
    end
  end
end