require "test_helper"

class ContactsMailerTest < ActionMailer::TestCase
  test "contacts mailer" do
    organization = ActsAsTenant.current_tenant
    sender = create(:user)
    message = "this is a test message"

    assert_emails 1 do
      @contact_email = ContactsMailer.with(name: sender.first_name,
        email: sender.email,
        message: message)
        .send_message(organization).deliver_now
    end

    assert_equal [organization.email], @contact_email.to
    assert_equal [Rails.application.config.from_email], @contact_email.from
    assert_match(/#{sender.first_name}/, @contact_email.body.encoded)
    assert_match(/#{sender.email}/, @contact_email.body.encoded)
    assert_match(/#{message}/, @contact_email.body.encoded)
  end
end
