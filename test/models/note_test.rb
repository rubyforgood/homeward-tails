require "test_helper"

class NoteTest < ActiveSupport::TestCase
  def setup
    @person = create(:person, :fosterer)
    notable = @person
    @note = Note.new(notable: notable, content: "This is a test note")
  end

  test "should be valid" do
    assert @note.valid?
  end

  test "should require a notable" do
    @note.notable = nil
    assert_not @note.valid?
  end

  test "should allow different notable types" do
    @application = create(:adopter_application, person: @person)
    note_for_application = Note.new(notable: @application, content: "Application note")
    assert note_for_application.valid?
  end
end
