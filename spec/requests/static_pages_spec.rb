require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples "a static page" do
    it "should have the right page title" do
      expect(page).to have_title(page_title)
    end
  end

  describe "Home page" do
    before { visit root_path }

    it_behaves_like "a static page" do
      let(:page_title) { 'Rewrittn' }
    end

    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }

      before do
        s1 = FactoryGirl.create(:snippet, user: user, content: "a" * 51)
        s1.create_activity :create, owner: user, parameters: { snippet_content: s1.content }

        s2 = FactoryGirl.create(:snippet, user: user, content: "b" * 51)
        s2.create_activity :create, owner: user, parameters: { snippet_content: s1.content }

        r1 = FactoryGirl.create(:rewrite, user: other_user, snippet: s1)
        r1.create_activity :create, owner: other_user, parameters: { snippet_content: s1.content, rewrite_title: r1.title }

        sign_in user
        visit root_path
      end

      it "should show the user's feed" do
        PublicActivity::Activity.all.each do |item|
          expect(page).to have_selector("li##{item.trackable_id}")
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 follower", href: followers_user_path(user)) }
      end
    end
  end

  describe "About page" do
    before { visit about_path }

    it_behaves_like "a static page" do
      let(:page_title) { 'About' }
    end
  end

  describe "Contact page" do
    before { visit contact_path }

    it_behaves_like "a static page" do
      let(:page_title) { 'Contact' }
    end
  end
end
