FactoryBot.define do
  factory :column do
    sequence(:name) { |i| "Column_test_#{i}" }
    association :project

    trait :invalid do
      name { nil }
    end
  end
end
