require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    before do
      # TODO Fix this mess
      #
      s1 = FactoryGirl.create(:snippet, user: user, content: "a" * 51)
      s1.create_activity :create, owner: user, parameters: { snippet_content: s1.content }

      s2 = FactoryGirl.create(:snippet, user: user, content: "b" * 51)
      s2.create_activity :create, owner: user, parameters: { snippet_content: s1.content }

      r1 = FactoryGirl.create(:anon_rewrite, user: other_user, snippet: s1)
      r1.create_activity :create, owner: other_user, parameters: { snippet_content: s1.content, rewrite_title: r1.title, tags: r1.tag_list }, anonymous: true

      r2 = FactoryGirl.create(:rewrite, user: user, snippet: s1)
      r2.create_activity :create, owner: user, parameters: { snippet_content: s1.content, rewrite_title: r2.title, tags: r2.tag_list }, anonymous: false

      visit user_path(user)
    end

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "activity feed" do
      before do
        sign_in user
        visit user_path(other_user)
      end

      it "should show the user's activity" do
        PublicActivity::Activity.where(owner_id: other_user.id, anonymous: false).each do |item|
          expect(page).to have_selector("li#s-#{item.trackable_id}")
        end
      end

      it "should not show activity from other users" do
        PublicActivity::Activity.where(owner_id: other_user.id).each do |item|
          expect(page).to_not have_selector("li#r-#{user.rewrites.last.id}")
        end
      end

      it "should not show anonymous rewrites to other users" do
        PublicActivity::Activity.where(owner_id: other_user.id) do |item|
          expect(page).to_not have_selector("li#r-#{other_user.rewrites.last.id}")
        end
      end

      it "should display tags for rewrites" do
        PublicActivity::Activity.where(owner_id: other_user.id) do |item|
          expect(page).to have_selector(".feed-item-rewrite-tags-tag a", text: "sci-fi", href: tags_path("sci-fi"))
        end
      end
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "should not be present on a user's own profile" do
        before { visit user_path(user) }
        it { should_not have_selector("div.star-form") }
      end

      context "when following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Star"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Star"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Star" }
          it { should have_xpath("//input[@value='Unstar']") }
        end
      end

      describe "unfollowing a user" do
        before do
          user.star!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unstar"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unstar"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unstar" }
          it { should have_xpath("//input[@value='Star']") }
        end
      end
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

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.star!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title('Following') }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title('Followers') }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end

  describe "snippets" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      31.times { FactoryGirl.create(:snippet, user: user) }
      visit snippets_user_path(user)
    end
    after { Snippet.delete_all }

    it { should have_selector('.pagination') }

    it "should list each snippet" do
      Snippet.paginate(page: 1).each do |snippet|
        expect(page).to have_selector('li', text: snippet.content)
      end
    end
  end

  describe "rewrites" do
    let(:user) { FactoryGirl.create(:user) }
    let(:snippet) { FactoryGirl.create(:snippet, user: user) }

    before do
      31.times { FactoryGirl.create(:rewrite, user: user, snippet: snippet) }
      visit rewrites_user_path(user)
    end
    after { Rewrite.delete_all }

    it { should have_selector('.pagination') }

    it "should list each rewrite" do
      Rewrite.paginate(page: 1).each do |rewrite|
        expect(page).to have_selector('li', text: rewrite.content_before_snippet || rewrite.content_after_snippet)
      end
    end
  end

  describe "reading list" do
    let(:user)    { FactoryGirl.create(:user) }
    let(:snippet) { FactoryGirl.create(:snippet) }

    before do
      31.times do
        rewrite = FactoryGirl.create(:rewrite, user: user, snippet: snippet)
        user.star!(rewrite)
      end
      visit root_path
    end

    it { should have_selector('.pagination') }

    describe "feed toggle" do
      it { should have_selector('.feed-toggle') }
    end

    describe "rewrites should have tags" do
      it { should have_selector(".reading-list-item-tags-tag") }
    end
  end
end
