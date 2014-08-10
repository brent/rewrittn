require 'spec_helper'

describe User do

  before { @user = User.new(name: "Brent Meyer", email: "brent.e.meyer@gmail.com",
                            password: "password", password_confirmation: "password") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:snippets) }
  it { should respond_to(:snippets_feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:star!) }
  it { should respond_to(:following?) }
  it { should respond_to(:unstar!) }
  it { should respond_to(:rewrites) }
  it { should respond_to(:rewrites_feed) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]

      addresses.each do |invalid|
        @user.email = invalid
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]

      addresses.each do |valid|
        @user.email = valid.downcase
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      dupe_email_user = @user.dup
      dupe_email_user.email = @user.email.downcase
      dupe_email_user.save
    end

    it { should_not be_valid }
  end

  describe "when password is blank" do
    before do 
      @user.password = ""
      @user.password_confirmation = ""
    end

    it { should_not be_valid }
  end

  describe "when passwords don't match" do
    before { @user.password_confirmation = "somethingelse" }
    it { should_not be_valid }
  end

  describe "when a password is too short" do
    before { @user.password = @user.password_confirmation = "pswrd" }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: "brent.e.meyer@gmail.com") }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "snippet associations" do

    before { @user.save }
    let!(:older_snippet) do
      FactoryGirl.create(:snippet, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_snippet) do
      FactoryGirl.create(:snippet, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right snippets in the right order" do
      expect(@user.snippets.to_a).to eq [newer_snippet, older_snippet]
    end

    it "should destroy associated snippets" do
      snippets = @user.snippets.to_a
      @user.destroy
      expect(snippets).not_to be_empty
      snippets.each do |snippet|
        expect(Snippet.where(id: snippet.id)).to be_empty
      end
    end

    describe "snippets feed" do
      let(:unfollowed_snippet) do
        FactoryGirl.create(:snippet, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.star!(followed_user)
        3.times { followed_user.snippets.create!(content: "a" * 51, source: @user) }
      end

      its(:snippets_feed) { should include(older_snippet) }
      its(:snippets_feed) { should include(newer_snippet) }
      its(:snippets_feed) { should_not include(unfollowed_snippet) }
      its(:snippets_feed) do
        followed_user.snippets.each do |snippet|
          should include(snippet)
        end
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.star!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "and unfollowing" do
      before { @user.unstar!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
  end

  describe "rewrite associations" do

    before { @user.save }
    let(:snippet) { FactoryGirl.create(:snippet, user: @user) }
    let!(:first_rewrite) do
      FactoryGirl.create(:rewrite, user: @user, snippet: snippet, created_at: 1.day.ago)
    end
    let!(:second_rewrite) do
      FactoryGirl.create(:rewrite, user: @user, snippet: snippet, created_at: 1.hour.ago)
    end

    it "should have the right rewrites in the right order" do
      expect(@user.rewrites.to_a).to eq [second_rewrite, first_rewrite]
    end

    it "should destroy associated rewrites" do
      rewrites = @user.rewrites.to_a
      @user.destroy
      expect(rewrites).not_to be_empty
      rewrites.each do |rewrite|
        expect(Rewrite.where(id: rewrite.id)).to be_empty
      end
    end

    describe "rewrites feed" do
      let(:unfollowed_user) do
        FactoryGirl.create(:user)
      end
      let(:unfollowed_rewrite) do
        FactoryGirl.create(:rewrite, user: unfollowed_user, snippet: FactoryGirl.create(:snippet, user: unfollowed_user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.star!(followed_user)
        3.times { followed_user.rewrites.create!(title: "I Really Hope This Works", content_before_snippet: "Content" * 40, snippet: FactoryGirl.create(:snippet, user: followed_user)) }
      end

      its(:rewrites_feed) { should include(first_rewrite) }
      its(:rewrites_feed) { should include(second_rewrite) }
      its(:rewrites_feed) { should_not include(unfollowed_rewrite) }
      its(:rewrites_feed) do
        followed_user.rewrites.each do |rewrite|
          should include(rewrite)
        end
      end
    end
  end
end
