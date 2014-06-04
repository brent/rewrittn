require 'spec_helper'

describe "Add Snippet Bookmarklet pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "index" do
    before { visit bookmarklet_path }

    it "should show the bookmarklet" do
      expect(page).to have_selector("a.bookmarklet")
    end
  end

  describe "add snippet page" do
    before { visit add_snippet_path }

    describe "with valid information" do
      let(:params) { { content: "test content to be added", source: "http://google.com" } }

      it "should return successful" do
        expect(page).to have_content("success")
      end
    end
  end
end
