require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "sign in page" do
    before { visit signin_path }

    it { should have_title('Sign in') }
    it { should have_content('Sign in') }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('.alert.alert-error') }

      describe "after visiting the Home page" do
        before { click_link "Rewrittn" }
        it { should_not have_selector('.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.downcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by sign out" do
        before { click_link "Sign out" }
        it { should have_link("Sign in") }
      end
    end
  end
end
