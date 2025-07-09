require "test_helper"

class FeedbackMailerTest < ActionMailer::TestCase
  test "send message" do
    message = "this is a test message"

    assert_emails 1 do
      @feedback_email = FeedbackMailer.with(name: "Test",
        email: "Test@test.com",
        message: message)
        .send_feedback.deliver_now
    end

    assert_equal [Rails.application.config.from_email], @feedback_email.to
    assert_equal [Rails.application.config.from_email], @feedback_email.from
    assert_match(/Test/, @feedback_email.body.encoded)
    assert_match(/Test@test.com/, @feedback_email.body.encoded)
    assert_match(/#{message}/, @feedback_email.body.encoded)
  end
end
