require "test_helper"

class FeedbackMailerTest < ActionMailer::TestCase
  test "send message" do
    sender = create(:user)
    message = "this is a test message"

    assert_emails 1 do
      @feedback_email = FeedbackMailer.with(name: sender.first_name,
        email: sender.email,
        message: message)
        .send_feedback.deliver_now
    end

    assert_equal [Rails.application.config.from_email], @feedback_email.to
    assert_equal [Rails.application.config.from_email], @feedback_email.from
    assert_match(/#{sender.first_name}/, @feedback_email.body.encoded)
    assert_match(/#{sender.email}/, @feedback_email.body.encoded)
    assert_match(/#{message}/, @feedback_email.body.encoded)
  end
end
