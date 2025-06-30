require "test_helper"

class FeedbackMailerTest < ActionMailer::TestCase
  test "send message" do
    organization = ActsAsTenant.current_tenant
    sender = create(:user)
    person = create(:person, user: sender, organization: organization, first_name: "John", last_name: "Doe")
    message = "this is a test message"

    Current.stubs(:person).returns(person)

    assert_emails 1 do
      @feedback_email = FeedbackMailer.with(name: person.full_name,
        email: sender.email,
        message: message)
        .send_feedback.deliver_now
    end

    assert_equal [Rails.application.config.from_email], @feedback_email.to
    assert_equal [Rails.application.config.from_email], @feedback_email.from
    assert_match(/John/, @feedback_email.body.encoded)
    assert_match(/#{sender.email}/, @feedback_email.body.encoded)
    assert_match(/#{message}/, @feedback_email.body.encoded)
  end
end
