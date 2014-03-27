namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_snippets
    make_relationships
  end
end

def make_users
  User.create!(name: "Brent Meyer",
                       email: "brent.e.meyer@gmail.com",
                       password: "password",
                       password_confirmation: "password",
                       admin: true)
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@email.com"
    password = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_snippets
  users = User.all(limit: 6)
  50.times do
    users.each { |user| user.snippets.create!(content: Faker::Lorem.sentence(20), source: user.name) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end
