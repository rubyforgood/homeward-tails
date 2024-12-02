require "test_helper"

class FosterMailerTest < ActionMailer::TestCase
  test "new_foster" do
    foster = create(:match, match_type: :foster, start_date: Date.current, end_date: Date.current + 10.days)
    email = FosterMailer.new_foster(foster)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [foster.person.email], email.to
    assert_equal [Rails.application.config.from_email], email.from
    assert_equal [foster.person.email], email.to
    assert_match(/#{foster.pet.name}/, email.subject)
    assert_match(/#{foster.pet.name}/, email.body.encoded)
  end
end
