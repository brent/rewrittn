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
