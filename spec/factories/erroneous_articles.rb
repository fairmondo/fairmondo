# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :erroneous_article do
    mass_upload_id 1
    validation_errors "MyText"
    article_csv "MyText"
  end
end
