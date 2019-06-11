FactoryBot.define do
  factory :column do
    sequence(:name) { |i| "Column_test_#{i}" }
    association :project
  end
end
