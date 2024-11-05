FactoryBot.define do
  factory :story do
    title { Faker::Book.title }
    content { Faker::Lorem.paragraphs.join("\n") }
    status { 'draft' }
    association :user
    association :category

    trait :published do
      status { 'published' }
    end
  end
end