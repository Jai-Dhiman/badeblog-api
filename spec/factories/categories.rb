FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "#{Faker::Book.genre} #{n}" }
  end
end