require 'spec_helper'

describe Rewrite do

  let(:user) { FactoryGirl.create(:user) }
  let(:snippet) { FactoryGirl.create(:snippet, user: user) }
  let(:rewrite) { FactoryGirl.create(:rewrite, user: user, snippet: snippet) }

  subject { rewrite }

  it { should respond_to(:content_before_snippet) }
  it { should respond_to(:content_after_snippet) }
  it { should respond_to(:user_id) }
  it { should respond_to(:snippet_id) }
  it { should respond_to(:title) }

  describe "when the user_id is not present" do
    before { rewrite.user_id = nil }
    it { should_not be_valid }
  end

  describe "when the snippet_id is not present" do
    before { rewrite.snippet_id = nil }
    it { should_not be_valid }
  end

  describe "when the title is not present" do
    before { rewrite.title = " " }
    it { should_not be_valid }
  end

  describe "when there is no content before or after snippet" do
    before { rewrite.content_before_snippet = rewrite.content_after_snippet = " " }
    it { should_not be_valid }
  end

  describe "when there is only content before the snippet" do
    before { rewrite.content_after_snippet = " " }
    it { should be_valid }
  end

  describe "when there is only content after the snippet" do
    before { rewrite.content_before_snippet = " " }
    it { should be_valid }
  end
end
