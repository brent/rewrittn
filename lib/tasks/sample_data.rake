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
  end
end
