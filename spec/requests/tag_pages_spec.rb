require 'spec_helper'

describe "Tag pages" do

  subject { page }

  describe "show" do
    before(:all) do
      u = FactoryGirl.create(:user)
      31.times { FactoryGirl.create(:rewrite, user: u, snippet: FactoryGirl.create(:snippet, user: u)) }
      visit tags_path(Rewrite.last.tag_list[0])
    end
    after(:all) do
      User.delete_all
      Rewrite.delete_all
    end

    it { should have_selector('.pagination') }
  end
end
