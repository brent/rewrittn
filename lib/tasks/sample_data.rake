namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
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

    users = User.all(limit: 6)
    50.times do
      users.each { |user| user.snippets.create!(content: Faker::Lorem.sentence(10), source: user.name) }
    end
  end
end
