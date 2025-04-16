require "test_helper"

class NoteTest < ActiveSupport::TestCase
  def setup
    @user = create(:fosterer)
    @notable = @user.person
    @note = Note.new(notable: @notable, notes: "This is a test note")
  end

  test "should be valid" do
    assert @note.valid?
  end

  test "should require a notable" do
    @note.notable = nil
    assert_not @note.valid?
  end

  test "should allow different notable types" do
    @application = create(:adopter_application, person: @user.person)
    note_for_application = Note.new(notable: @application, notes: "Application note")
    assert note_for_application.valid?
  end
end
