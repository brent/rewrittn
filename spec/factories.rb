FactoryGirl.define do
  factory :user do
    name                  "Evan Key"
    email                 "thenamelessone@gmail.com"
    password              "password"
    password_confirmation "password"
  end
end
