FactoryBot.define do
  factory :user, aliases: [:owner] do
    provider { Faker::Omniauth.unique.google[:provider] }
    uid { Faker::Omniauth.unique.google[:uid] }
    name { Faker::Omniauth.unique.google[:info][:name] }
  end
end
