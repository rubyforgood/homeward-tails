require "test_helper"

class ContactsMailerTest < ActionMailer::TestCase
  test "contacts mailer" do
    organization = ActsAsTenant.current_tenant
    message = "this is a test message"

    assert_emails 1 do
      @contact_email = ContactsMailer.with(name: "Test",
        email: "Test@test.com",
        message: message)
        .send_message(organization).deliver_now
    end

    assert_equal [organization.email], @contact_email.to
    assert_equal [Rails.application.config.from_email], @contact_email.from
    assert_match(/Test/, @contact_email.body.encoded)
    assert_match(/Test@test.com/, @contact_email.body.encoded)
    assert_match(/#{message}/, @contact_email.body.encoded)
  end
end
