FactoryBot.define do
  factory :invitation do
    association :project
    association :user
  end
end
