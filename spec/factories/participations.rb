FactoryBot.define do
  factory :participation do
    association :project
    association :user
  end
end
