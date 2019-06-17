# アプリの使用方法をわかりやすくするため、ある程度プロジェクトが登録された状態を作る
# （必要に応じて実行する）

# users
10.times do
  auth = [
    Faker::Omniauth.unique.google,
    Faker::Omniauth.unique.twitter,
    Faker::Omniauth.unique.github
  ].sample
  provider = auth[:provider]
  uid = auth[:uid]
  name = auth[:info][:name]

  user = User.create!(
    name: name,
    provider: provider,
    uid: uid
  )

  File.open("#{Rails.root}/public/avatar_sample.jpg") do |file|
    user.image.attach(io: file,
                      filename: 'avatar_sample.jpg',
                      content_type: 'image/jpeg')
  end
end

# projects
100.times do |n|
  Project.create!(
    name: "プロジェクト#{n + 1}",
    summary: "プロジェクト#{n + 1}の概要",
    owner_id: User.ids.sample
  )
end

# my_projects
# 最初に登録したユーザのプロジェクトが100件登録される
user = User.first
100.times do |n|
  Project.create!(
    name: "プロジェクト#{n + 1001}",
    summary: "プロジェクト#{n + 1001}の概要",
    owner: user
  )
end
