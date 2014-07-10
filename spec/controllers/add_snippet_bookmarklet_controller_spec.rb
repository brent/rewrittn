require 'spec_helper'

describe AddSnippetBookmarkletController do

  let(:user) { FactoryGirl.create(:user) }

  describe "GET create" do

    describe "when not signed in" do

      it "should not add a snippet" do
        expect do
        xhr :get, :create, snippet: { source: "http://google.com", content: "a" * 51 }
        end.not_to change(Snippet, :count).by(1)
      end

      it "should not respond with success" do
        xhr :get, :create, snippet: { source: "http://google.com", content: "a" * 51 }
        expect(response.response_code).to eq 401
      end
    end

    describe "with appropriate params" do

      before { sign_in user, no_capybara: true }

      it "should add a snippet" do
        expect do
          xhr :get, :create, snippet: { source: "http://google.com", content: "a" * 51 }
        end.to change(Snippet, :count).by(1)
      end

      it "should respond with success" do
        xhr :get, :create, snippet: { source: "http://google.com", content: "a" * 51 }
        expect(response.response_code).to eq 200
      end
    end

    describe "with bad params" do

      before { sign_in user, no_capybara: true }

      it "should not add a snippet" do
        expect do
          xhr :get, :create, snippet: { source: "", content: "" }
        end.not_to change(Snippet, :count).by(1)
      end

      it "should not respond with success" do
        xhr :get, :create, snippet: { source: "", content: "" }
        expect(response.response_code).to eq 400
      end
    end
  end
end
