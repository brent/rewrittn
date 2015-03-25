FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person-#{n}@email.com" }
    password              "password"
    password_confirmation "password"

    factory :admin do
      admin true
    end
  end

  factory :snippet do
    content "s" * 51
    source "http://google.com/"
    user
  end

  factory :anon_rewrite, class: Rewrite do
    title "t" * 10
    content_before_snippet ("u" * 101)
    content_after_snippet ("v" * 101)
    user
    snippet
    anonymous true
  end

  factory :rewrite do
    title "w" * 10
    content_before_snippet ("x" * 101)
    content_after_snippet ("y" * 101)
    user
    snippet
    anonymous false
  end
end
