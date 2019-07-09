FactoryBot.define do
  factory :card do
    sequence(:name) { |i| "Card_test_#{i}" }
    due_date { Faker::Date.forward(30) }
    project { column.project }
    assignee_id { column.project.owner.id }
    association :column
  end
end
