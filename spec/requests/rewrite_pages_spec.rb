require 'spec_helper'

describe "Rewrite pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:snippet) { FactoryGirl.create(:snippet, user: user) }
  before { sign_in user }

  describe "index" do
    before do
      visit rewrites_path
    end

    describe "pagination" do
      before(:all) do
        u = FactoryGirl.create(:user)
        31.times { FactoryGirl.create(:rewrite, user: u, snippet: FactoryGirl.create(:snippet, user: u)) }
      end
      after(:all) do
        User.delete_all
        Rewrite.delete_all
      end

      it { should have_selector('.pagination') }

      it "should list each user" do
        Rewrite.paginate(page: 1).each do |rewrite|
          expect(page).to have_selector('li', text: rewrite.snippet.content)
        end
      end
    end
  end

  describe "show" do
    let(:rewrite) { FactoryGirl.create(:rewrite, user: user, snippet: snippet) }
    before do
      visit rewrite_path(rewrite)
    end

    it "should display the rewrite" do
      expect(page).to have_content(rewrite.content_before_snippet || rewrite.content_after_snippet)
    end
  end

  describe "rewrite creation" do
    before do
      visit snippet_path(snippet)
      click_link "rewrite"
    end

    describe "with invalid information" do
      it "should not create a rewrite" do
        expect { click_button "publish" }.not_to change(Rewrite, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in 'Title', with: 'A' * 15
        fill_in 'rewrite_content_before_snippet', with: 'B' * 101
        fill_in 'rewrite_content_after_snippet',  with: 'C' * 101
      end

      it "should create a rewrite" do
        expect { click_button "publish" }.to change(Rewrite, :count).by(1)
      end
    end
  end
end
