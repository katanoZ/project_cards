FactoryBot.define do
  factory :user do
    auth = [
      Faker::Omniauth.google,
      Faker::Omniauth.twitter,
      Faker::Omniauth.github
    ].sample

    provider { auth[:provider] }
    uid { auth[:uid] }
    name { auth[:info][:name] }
  end
end
