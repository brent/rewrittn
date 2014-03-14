require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "Sign up page" do
    before { visit signup_path }

    it "should have the right title" do
      expect(page).to have_title('Sign up')
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it "should be the user's profile" do
      expect(page).to have_content(user.name)
    end
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Sign up" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",             with: "New User"
        fill_in "Email",            with: "brent.e.meyer@gmail.com"
        fill_in "Password",         with: "password"
        fill_in "Confirm password", with: "password"
      end

      it "should create a new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { FactoryGirl.create(:user) }

        it { should have_link("Sign out") }
        it { should have_selector('.alert.alert-success', text: 'Welcome') }
        it { should_not have_link("Sign in") }
      end
    end
  end
end
