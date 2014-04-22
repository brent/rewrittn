namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_snippets
    make_relationships
    make_rewrites
    make_activity
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

def make_rewrites
  users = User.all(limit: 6)
  30.times do |n|
    users.each do |user|
      if (n + 1) % 2 == 0
        user.rewrites.create!(title: Faker::Lorem.sentence(10),
                              content_before_snippet: Faker::Lorem.sentence(40),
                              snippet: Snippet.find(n+1))
      elsif (n + 1) % 3 == 0
        user.rewrites.create!(title: Faker::Lorem.sentence(10),
                              content_after_snippet: Faker::Lorem.sentence(40),
                              snippet: Snippet.find(n+1))
      else
        user.rewrites.create!(title: Faker::Lorem.sentence(10),
                              content_before_snippet: Faker::Lorem.sentence(20),
                              content_after_snippet: Faker::Lorem.sentence(20),
                              snippet: Snippet.find(n+1))
      end
    end
  end
end

def make_activity
  users = User.all(limit: 6)
  20.times do |n|
    users.each do |user|
      if n % 2 == 0
        user.snippets[n+1].create_activity(owner: user,
                                           key: "snippet.create",
                                           parameters: { snippet_content: user.snippets[n+1].content })
      else
        user.rewrites[n+1].create_activity(owner: user,
                                           key: "rewrite.create",
                                           parameters: { rewrite_title: user.rewrites[n+1].title,
                                                         snippet_content: user.snippets[n+1].content })
      end
    end
  end
end
