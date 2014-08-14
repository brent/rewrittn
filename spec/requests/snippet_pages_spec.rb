require 'spec_helper'

describe "Snippet pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "show" do
    let(:snippet) { FactoryGirl.create(:snippet, user: user) }
    before do
      visit snippet_path(snippet)
    end

    it "should display the snippet" do
      expect(page).to have_content(snippet.content)
    end

    it "should have a rewrite button" do
      expect(page).to have_link("rewrite", href: new_rewrite_path(snippet: snippet.id))
    end

    describe "star/unstar buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      let(:other_snippet) { FactoryGirl.create(:snippet, user: other_user) }
      before { visit snippet_path(other_snippet) }

      it "should have the star button" do
        expect(page).to have_selector('.star-btn')
      end

      describe "starring a snippet" do
        it "should increment the starred snippets count" do
          expect do
            click_button "Star"
          end.to change(user.starred_snippets, :count).by(1)
        end
      end

      describe "toggling the button" do
        before { click_button "Star" }
        it { should have_xpath("//input[@value='Unstar']") }
      end
    end
  end

  describe "snippet creation" do
    before { visit new_snippet_path }

    describe "with invalid information" do

      it "should not create a snippet" do
        expect { click_button "Add snippet" }.not_to change(Snippet, :count)
      end
    end

    describe "with valid information" do

      before do
        fill_in 'Content', with: 'x'*51
        fill_in 'Source', with: "http://www.google/com"
      end

      it "should create a snippet" do
        expect { click_button "Add snippet" }.to change(Snippet, :count).by(1)
      end
    end
  end

  describe "snippet destruction" do
    let(:snippet) { FactoryGirl.create(:snippet, user: user) }

    describe "as correct user" do
      before { visit snippet_path(snippet) }

      it "should delete a snippet" do
        expect { click_link "delete" }.to change(Snippet, :count).by(-1)
      end
    end
  end
end
