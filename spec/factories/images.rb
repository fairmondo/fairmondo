FactoryGirl.define do
  factory :image do
    article
    image_file_name       "image"
    image_content_type    "image/png"
    image_file_size       { Random.new.rand(0..5) }
  end
end