require 'spec_helper'

describe AddSnippetBookmarkletController do

  let(:user) { FactoryGirl.create(:user) }

  before { sign_in user, no_capybara: true }

  describe "GET create" do

    describe "with appropriate params" do

      it "should add a snippet" do
        expect do
          xhr :get, :create, snippet: { source: "http://google.com", content: "a" * 51 }
        end.to change(Snippet, :count).by(1)
      end

      it "should respond with success" do
        xhr :get, :create, snippet: { source: "http://google.com", content: "a" * 51 }
        expect(response).to be_success
      end
    end

    describe "with bad params" do

      it "should not add a snippet" do
        expect do
          xhr :get, :create, snippet: { source: "", content: "" }
        end.not_to change(Snippet, :count).by(1)
      end

      it "should not respond with success" do
        xhr :get, :create, snippet: { source: "", content: "" }
        expect(response.body).to have_content "fail"
      end
    end
  end
end
