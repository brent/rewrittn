require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:s1) { FactoryGirl.create(:snippet, user: user, content: "1" * 51, source: "user") }
    let!(:s2) { FactoryGirl.create(:snippet, user: user, content: "2" * 51, source: "user") }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "snippets" do
      it { should have_content(s1.content) }
      it { should have_content(s2.content) }
      it { should have_content(user.snippets.count) }
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title("users") }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }

        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update profile") }
      it { should have_title("Edit") }
    end

    describe "with invalid information" do
      before { click_button "Update" }
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@email.com" }

      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm password", with: user.password
        click_button "Update"
      end

      it { should have_title(new_name) }
      it { should have_selector('.alert.alert-success') }
      it { should have_link("Sign out", href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end
