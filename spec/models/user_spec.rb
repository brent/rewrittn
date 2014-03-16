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
end
