require 'spec_helper'

describe Snippet do

  let(:user) { FactoryGirl.create(:user) }
  before do
    @snippet = user.snippets.build(content: "S" * 51, source: "user")
  end

  subject { @snippet }

  it { should respond_to(:content) }
  it { should respond_to(:source) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:rewrites) }
  its(:user) { should eq user }

  describe "when user_id is not present" do
    before { @snippet.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @snippet.content = "" }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @snippet.content = "x" * 501 }
    it { should_not be_valid }
  end

  describe "with blank source" do
    before { @snippet.source = "" }
    it { should_not be_valid }
  end
end
