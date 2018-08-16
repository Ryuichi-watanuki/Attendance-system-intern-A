# ユーザー
User.create!(name:  "綿貫　竜一",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             affiliation: "管理者",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "一般ユーザー",
             email: "example2@railstutorial.org",
             password:              "foobarr",
             password_confirmation: "foobarr",
             affiliation: "一般",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)

# coding: utf-8

50.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  affiliation = "一般ユーザー"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               affiliation:        affiliation,
               activated: true,
               activated_at: Time.zone.now)
end

# マイクロポスト
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }