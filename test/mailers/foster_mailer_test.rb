require "test_helper"

class AdoptionMailerTest < ActionMailer::TestCase
  test "foster_reminder" do
    foster = create(:match, match_type: :foster, start_date: Date.current, end_date: Date.current + 10.days)
    email = AdoptionMailer.new_adoption(foster)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [foster.person.email], email.to
    assert_match(/#{foster.pet.name}/, email.subject)
    assert_match(/#{foster.pet.name}/, email.body.encoded)
  end
end
