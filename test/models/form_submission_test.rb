require "test_helper"

class FormSubmissionTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:person)
    should have_many(:form_answers).dependent(:destroy)
  end
end
