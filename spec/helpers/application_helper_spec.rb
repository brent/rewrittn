require 'spec_helper'

describe ApplicationHelper do

  describe "full_title" do
    it "should include the page title" do
      expect(full_title("foo")).to match(/foo/)
    end

    it "should include the base title" do
      expect(full_title("foo")).to match(/^Rewrittn/)
    end

    it "should not include a bar on the home page" do
      expect(full_title("")).not_to match(/\|/)
    end
  end
end
