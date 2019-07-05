FactoryBot.define do
  factory :project do
    sequence(:name) { |i| "Project_test_#{i}" }
    sequence(:summary) { |i| "test_summary_#{i}" }
    association :owner

    trait :invalid do
      name { nil }
    end
  end
end
