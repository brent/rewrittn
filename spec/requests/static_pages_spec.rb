require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do

    it "should have the content 'Rewrittn'" do
      visit '/static_pages/home'
      expect(page).to have_content('Rewrittn')
    end

    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title('Rewrittn')
    end
  end

  describe "About page" do
    it "should have the content 'About'" do
      visit '/static_pages/about'
      expect(page).to have_content('About')
    end

    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title('About')
    end
  end
end
