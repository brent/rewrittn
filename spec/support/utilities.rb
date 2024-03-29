def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara--more specifically, for sending direct requests (GET, POST, PATCH, DELETE)
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
  else
    visit signin_path
    fill_in "Email",     with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end
