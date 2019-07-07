FactoryBot.define do
  factory :log do
    association :project
    sequence(:content) { |i| "Test_log_content#{i}" }
  end
end
