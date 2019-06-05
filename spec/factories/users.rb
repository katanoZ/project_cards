FactoryBot.define do
  factory :user do
    auth = [
      Faker::Omniauth.unique.google,
      Faker::Omniauth.unique.twitter,
      Faker::Omniauth.unique.github
    ].sample

    provider { auth[:provider] }
    uid { auth[:uid] }
    name { auth[:info][:name] }
  end
end
