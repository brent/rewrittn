require 'spec_helper'

describe "Add Snippet Bookmarklet pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "index" do
    before { visit bookmarklet_path }

    it "should display the bookmarklet" do
      expect(page).to have_selector("a#add_snippet_bookmarklet")
    end
  end
end
